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

final class UserViewModel: ObservableObject {
    
    @Published var user: UserModel
    @Published var isLoggedIn: Bool = false
    @Published var error: Error?
    
    init(user: UserModel) {
        self.user = user
    }
    
    func handleLogin() {
        switch user.oAuthType {
        case .kakao:
            handleKakaoLogin()
        case .google:
            handleGoogleLogin()
        default:
            break
        }
    }
    
    func handleLogout() {
        switch user.oAuthType {
        case .kakao:
            handleKakaoLogout()
        case .google:
            handleGoogleLogout()
        default:
            break
        }
    }
    
    private func handleKakaoLogin() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error {
                    self.error = error
                }
                if let oauthToken {
                    self.user.oAuthType = .kakao
                    self.user.token = "\(oauthToken)"
                    self.getKakaoUserDetail()
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error {
                    self.error = error
                }
                if let oauthToken {
                    self.user.oAuthType = .kakao
                    self.user.token = "\(oauthToken)"
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
                self.user.token = ""
                self.user.name = ""
                self.user.email = ""
                self.user.oAuthType = .unknown
                self.error = nil
                self.isLoggedIn  = false
            }
        }
    }
    
    private func getKakaoUserDetail() {
        UserApi.shared.me() { (user, error) in
            if let error {
                self.error = error
            }
            if let name = user?.kakaoAccount?.profile?.nickname {
                self.user.name = name
                self.isLoggedIn = true
            }
        }
    }
    
    private func handleGoogleLogin() {
        
    }
    
    private func handleGoogleLogout() {
        
    }
    
    private func getGoogleUserDetail() {
        
    }
}
