//
//  UserViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/26.
//

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn
import Firebase
import FirebaseFirestoreSwift
import Combine

final class AuthManager: ObservableObject {
    @Published var userModel: UserModel?
    @Published var error: Error?
    @Published var isLoading: Bool = true
    @Published var isLoggedIn: Bool = false
    
    var auth: AuthDTO?
    var firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
    }
    
    func checkLogin() {
        guard let latestOAuthType = UserDefaults.standard.object(forKey: "latestOAuthType") as? String,
        let oAuthType = OAuthType(rawValue: latestOAuthType) else { return }
        
        switch oAuthType {
        case .kakao:
            checkKakaoLogin()
        case .google:
            checkGoogleLogin()
        default:
            return
        }
    }
    
    func checkKakaoLogin() {
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { _, error in
                if let error {
                    self.error = error
                    self.isLoading = false
                } else {
                    self.fetchKakaoUserDetail()
                }
            }
        } else {
            self.isLoading = false
        }
    }
    
    func checkGoogleLogin() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error {
                self.error = error
                self.isLoading = false
            }
            if let user,
               let profile = user.profile {
                Task {
                    await self.fetchUserData(name: profile.name, email: profile.email, type: .google)
                }
            }
        }
    }
    
    func handleLogin(for type: OAuthType) {
        switch type {
        case .kakao:
            handleKakaoLogin()
        case .google:
            handleGoogleLogin()
        default:
            break
        }
    }
    
    private func handleKakaoLogin() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { _, error in
                if let error {
                    self.error = error
                } else {
                    self.fetchKakaoUserDetail()
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { _, error in
                if let error {
                    self.error = error
                } else {
                    self.fetchKakaoUserDetail()
                }
            }
        }
    }
    
    private func handleGoogleLogin() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first
                                              as? UIWindowScene)?.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            if let error {
                self.error = error
            }
            if let result,
               let profile = result.user.profile {
                Task {
                    await self.fetchUserData(name: profile.name, email: profile.email, type: .google)
                }
            }
        }
    }
    
    private func fetchKakaoUserDetail() {
        UserApi.shared.me() { user, error in
            if let error {
                self.error = error
            }
            guard let name = user?.kakaoAccount?.profile?.nickname,
                  let email = user?.kakaoAccount?.email else {
                self.error = MinimoError.unknown
                return
            }
            Task {
                await self.fetchUserData(name: name, email: email, type: .kakao)
            }
        }
    }
    
    func handleLogout() {
        guard let auth else { return }
        switch auth.oAuthType {
        case .kakao:
            handleKakaoLogout()
        case .google:
            handleGoogleLogout()
        default:
            break
        }
    }
    
    private func handleKakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                self.error = error
            }
            else {
                self.auth = nil
                self.userModel = nil
                self.error = nil
            }
        }
    }
    
    private func handleGoogleLogout() {
        GIDSignIn.sharedInstance.signOut()
        self.auth = nil
        self.userModel = nil
        self.error = nil
    }
    
    private func fetchUserData(name: String, email: String, type: OAuthType) async {
        do {
            let authQuery = Filter.andFilter([
                Filter.whereField("email", isEqualTo: email),
                Filter.whereField("oAuthType", isEqualTo: type.rawValue)
            ])
            let authData: AuthDTO = try await firebaseManager.readSingleDataAsync(from: .auth, query: authQuery)
            let userQuery = Filter.whereField("id", isEqualTo: authData.user.uuidString)
            
            let user: UserDTO = try await firebaseManager.readSingleDataAsync(from: .users, query: userQuery)
            
            await MainActor.run {
                auth = authData
                userModel = UserModel(user: user, firebaseManager: self.firebaseManager)
                UserDefaults.standard.setValue(type.rawValue, forKey: "latestOAuthType")
                isLoading = false
                isLoggedIn = true
            }
        } catch {
            // TODO: Auth / User 각각의 데이터 없을 때에 맞춰서 다르게 생성(User만 없으면 Auth에 맞춰서 생성해야 함)
            addUser(name: name, email: email, type: type)
        }
        
    }
    
    private func addUser(name: String, email: String, type: OAuthType) {
        let newUser = UserDTO(id: UUID(),
                              name: name)
        let newAuth = AuthDTO(id: UUID(),
                              email: email,
                              oAuthType: type,
                              createdAt: Date(),
                              user: newUser.id)
        
        Task { [newUser, newAuth] in
            try await firebaseManager.createData(to: .auth, data: newAuth)
            try await firebaseManager.createData(to: .users, data: newUser)
            
            await MainActor.run {
                auth = newAuth
                userModel = UserModel(user: newUser, firebaseManager: self.firebaseManager)
                UserDefaults.standard.setValue(type.rawValue, forKey: "latestOAuthType")
                isLoading = false
                isLoggedIn = true
            }
        }
    }
}
