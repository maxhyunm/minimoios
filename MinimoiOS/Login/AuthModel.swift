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
                        self.getKakaoUserDetail()
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
                    self.getGoogleUserDetail(profile: profile)
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
                    self.getKakaoUserDetail()
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { _, error in
                if let error {
                    self.error = error
                } else {
                    self.getKakaoUserDetail()
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
    
    private func getKakaoUserDetail() {
        UserApi.shared.me() { user, error in
            if let error {
                self.error = error
            }
            guard let name = user?.kakaoAccount?.profile?.nickname,
                  let email = user?.kakaoAccount?.email else {
                self.error = MinimoError.unknown
                return
            }
            
            self.getUserData(email: email, type: .kakao).sink { completion in
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
                self.getGoogleUserDetail(profile: profile)
            }
        }
    }
    
    private func getGoogleUserDetail(profile: GIDProfileData) {
        getUserData(email: profile.email, type: .google).sink { completion in
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
    
    private func getUserData(email: String, type: OAuthType) -> Future<[UserDTO], MinimoError> {
        let query = Filter.andFilter([
            Filter.whereField("email", isEqualTo: email),
            Filter.whereField("oAuthType", isEqualTo: type.rawValue)
        ])
        return firebaseManager.readQeuryData(from: "users", query: query)
    }
    
    private func addUser(name: String, email: String, type: OAuthType) {
        let newUser = UserDTO(
            id: UUID(),
            name: name,
            email: email,
            oAuthType: type
        )
        firebaseManager.createData(to: "users", data: newUser)
        self.user = newUser
    }
}
