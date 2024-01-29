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
    var firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
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
    
    func handleLogout() {
        guard let user else { return }
        switch user.oAuthType {
        case .kakao:
            handleKakaoLogout()
        case .google:
            handleGoogleLogout()
        default:
            break
        }
    }
    
    func checkLogin() {
        guard let latestOAuthType = UserDefaults.standard.object(forKey: "latestOAuthType") as? String,
        let oAuthType = OAuthType(rawValue: latestOAuthType) else { return }
        
        switch oAuthType {
        case .kakao:
            if AuthApi.hasToken() {
                UserApi.shared.accessTokenInfo { _, error in
                    if let error {
                        self.error = error
                    } else {
                        self.fetchKakaoUserDetail()
                    }
                }
            }
        case .google:
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if let error {
                    self.error = error
                }
                if let user,
                   let profile = user.profile {
                    self.fetchGoogleUserDetail(profile: profile)
                }
            }
        default:
            return
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
    
    private func handleKakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                self.error = error
            }
            else {
                self.user = nil
                self.error = nil
                self.isLoggedIn  = false
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
            
            self.fetchUserData(email: email, type: .kakao).sink { completion in
                    switch completion {
                    case.finished:
                        break
                    case .failure(let error):
                        if error == MinimoError.dataNotFound {
                            self.addUser(name: name, email: email, type: .kakao)
                        } else {
                            self.error = error
                        }
                    }
                } receiveValue: { user in
                    guard let userData = user.first else { return }
                    self.user = userData
                    UserDefaults.standard.setValue(OAuthType.kakao.rawValue, forKey: "latestOAuthType")
                    self.isLoggedIn = true
                }
                .store(in: &self.cancellables)
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
                self.fetchGoogleUserDetail(profile: profile)
            }
        }
    }
    
    private func fetchGoogleUserDetail(profile: GIDProfileData) {
        fetchUserData(email: profile.email, type: .google).sink { completion in
            switch completion {
            case.finished:
                break
            case .failure(let error):
                if error == MinimoError.dataNotFound {
                    self.addUser(name: profile.name, email: profile.email, type: .google)
                } else {
                    self.error = error
                }
            }
        } receiveValue: { user in
            guard let userData = user.first else { return }
            self.user = userData
            UserDefaults.standard.setValue(OAuthType.google.rawValue, forKey: "latestOAuthType")
            self.isLoggedIn = true
        }
        .store(in: &cancellables)
    }
    
    private func handleGoogleLogout() {
        GIDSignIn.sharedInstance.signOut()
        self.user = nil
        self.error = nil
        self.isLoggedIn  = false
    }
    
    private func fetchUserData(email: String, type: OAuthType) -> Future<[UserDTO], MinimoError> {
        let query = Filter.andFilter([
            Filter.whereField("email", isEqualTo: email),
            Filter.whereField("oAuthType", isEqualTo: type.rawValue)
        ])
        return firebaseManager.readQueryData(from: "users", query: query, orderBy: "createdAt", descending: false, limit: 1)
    }
    
    private func addUser(name: String, email: String, type: OAuthType) {
        let newUser = UserDTO(
            id: UUID(),
            name: name,
            email: email,
            createdAt: Date(),
            oAuthType: type
        )
        firebaseManager.createData(to: "users", data: newUser)
        self.user = newUser
    }
}
