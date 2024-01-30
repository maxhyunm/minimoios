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

final class AuthModel: ObservableObject {
    @Published var user: UserDTO?
    @Published var isLoggedIn: Bool = false
    @Published var error: Error?
    @Published var isLoading: Bool = true
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
                } else {
                    self.fetchKakaoUserDetail()
                }
            }
        }
    }
    
    func checkGoogleLogin() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error {
                self.error = error
            }
            if let user,
               let profile = user.profile {
                self.fetchUserDetail(name: profile.name, email: profile.email, type: .google)
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
                self.fetchUserDetail(name: profile.name, email: profile.email, type: .google)
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
            self.fetchUserDetail(name: name, email: email, type: .kakao)
        }
    }
    
    private func fetchUserDetail(name: String, email: String, type: OAuthType) {
        fetchAuthData(email: email, type: type).sink { completion in
            switch completion {
            case.finished:
                break
            case .failure(let error):
                if error == MinimoError.dataNotFound {
                    self.addUser(name: name, email: email, type: type)
                } else {
                    self.error = error
                }
            }
        } receiveValue: { auth in
            guard let authData = auth.first else { return }
            self.auth = authData
            self.fetchUserData(auth: authData).sink { completion in
                switch completion {
                case.finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: { user in
                self.user = user
                UserDefaults.standard.setValue(type.rawValue, forKey: "latestOAuthType")
                self.isLoggedIn = true
            }
            .store(in: &self.cancellables)
        }
        .store(in: &cancellables)
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
                self.user = nil
                self.error = nil
                self.isLoggedIn  = false
            }
        }
    }
    
    private func handleGoogleLogout() {
        GIDSignIn.sharedInstance.signOut()
        self.auth = nil
        self.user = nil
        self.error = nil
        self.isLoggedIn  = false
    }
    
    private func fetchAuthData(email: String, type: OAuthType) -> Future<[AuthDTO], MinimoError> {
        let query = Filter.andFilter([
            Filter.whereField("email", isEqualTo: email),
            Filter.whereField("oAuthType", isEqualTo: type.rawValue)
        ])
        return firebaseManager.readQueryData(from: "auth", query: query, orderBy: "createdAt", descending: false, limit: 1)
    }
    
    private func fetchUserData(auth: AuthDTO) -> Future<UserDTO, MinimoError> {
        let query = Filter.whereField("id", isEqualTo: auth.user.uuidString)
        return firebaseManager.readUserData(for: auth.user)
    }
    
    private func addUser(name: String, email: String, type: OAuthType) {
        let newUser = UserDTO(id: UUID(),
                              name: name)
        let newAuth = AuthDTO(id: UUID(),
                              email: email,
                              oAuthType: type,
                              createdAt: Date(),
                              user: newUser.id)
        firebaseManager.createData(to: "auth", data: newAuth)
        firebaseManager.createData(to: "users", data: newUser)
        self.auth = newAuth
        self.user = newUser
        UserDefaults.standard.setValue(type.rawValue, forKey: "latestOAuthType")
        self.isLoggedIn = true
    }
}
