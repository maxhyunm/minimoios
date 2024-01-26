//
//  KakaoAuth.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/26.
//

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import Combine

class KakaoAuthViewModel: ObservableObject {
    @Published var userToken: OAuthToken?
    @Published var userName: String?
    @Published var error: Error?
    @Published var isLogin: Bool = false
    
    func loginWithKakao() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error {
                    self.error = error
                }
                if let oauthToken {
                    self.userToken = oauthToken
                    self.getUserName()
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error {
                    self.error = error
                }
                if let oauthToken {
                    self.userToken = oauthToken
                    self.getUserName()
                }
            }
        }
    }
    
    func getUserName() {
        UserApi.shared.me() { (user, error) in
            if let error {
                self.error = error
            }
            if let name = user?.kakaoAccount?.profile?.nickname {
                self.userName = name
                self.isLogin = true
            }
        }
    }
    
    func logoutWithKakao() {
        UserApi.shared.logout {(error) in
            if let error = error {
                self.error = error
            }
            else {
                self.userToken = nil
                self.userName = nil
                self.error = nil
                self.isLogin = false
            }
        }
    }
}
