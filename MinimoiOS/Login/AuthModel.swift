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
import Combine

final class AuthModel: ObservableObject {
    @Published var user: UserDTO?
    @Published var isLoggedIn: Bool = false
    @Published var error: Error?
    
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
                    if error == nil {
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
                   let userEmail = user.profile?.email {
                    do {
                        if let userData = try self.getUserData(email: userEmail) {
                            self.user = userData
                            self.isLoggedIn = true
                        }
                    } catch(let error) {
                        self.error = error
                    }
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
            if let name = user?.kakaoAccount?.profile?.nickname,
               let email = user?.kakaoAccount?.email {
                do {
                    if let userData = try self.getUserData(email: email) {
                        self.user = userData
                    } else {
                        // TODO: 새 유저 만들기
                        self.addUser(name: name,
                                     email: email,
                                     type: OAuthType.kakao)
                    }
                    UserDefaults.standard.setValue(OAuthType.kakao.rawValue, forKey: "latestOAuthType")
                    self.isLoggedIn = true
                } catch(let error) {
                    self.error = error
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
                do {
                    if let userData = try self.getUserData(email: profile.email) {
                        self.user = userData
                    } else {
                        // TODO: 새 유저 만들기
                        self.addUser(name: profile.name,
                                     email: profile.email,
                                     type: OAuthType.google)
                    }
                    UserDefaults.standard.setValue(OAuthType.google.rawValue, forKey: "latestOAuthType")
                    self.isLoggedIn = true
                } catch(let error) {
                    self.error = error
                }
            }
        }
    }
    
    private func handleGoogleLogout() {
        GIDSignIn.sharedInstance.signOut()
        self.user = nil
        self.error = nil
        self.isLoggedIn  = false
    }
    
    private func getUserData(email: String) throws -> UserDTO? {
        let allUsers: [UserDTO] = try DecodingManager.shared.loadFile("test_user.json")
        let filtered = allUsers.filter { $0.email == email }
        guard let user = filtered.first else { return nil }
        return user
    }
    
    private func addUser(name: String, email: String, type: OAuthType) {
        // TODO: 새 유저 만들기
        self.user = UserDTO(
            id: UUID(),
            name: name,
            email: email,
            oAuthType: type
        )
    }
}
