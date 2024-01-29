//
//  OAuthProtocol.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/26.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser


enum OAuthType: String {
    case kakao = "KAKAO"
    case google = "GOOGLE"
    case unknown = "UNKNOWN"
}
//
//struct OAuthManager {
//    func checkKakaoLogin() -> UserDTO? {
//        guard AuthApi.hasToken() else { return nil }
//        UserApi.shared.accessTokenInfo { _, error in
//            if error == nil {
//                self.getKakaoUserDetail().sink{ _ in } receiveValue: { user in
//                    return user
//                }
//            }
//        }
//    }
//
//    func getKakaoUserDetail() -> Future<UserDTO, Error> {
//        return Future { promise in
//
//        }
//    }
//}
//
//
//
//func checkLogin() {
//
//    switch oAuthType {
//    case .kakao:
//
//    case .google:
//        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//            if let error {
//                self.error = error
//            }
//
//            if let user,
//               let profile = user.profile {
//                self.getGoogleUserDetail(profile: profile)
//            }
//        }
//    default:
//        return
//    }
//}
//
//private func handleKakaoLogin() {
//    if (UserApi.isKakaoTalkLoginAvailable()) {
//        UserApi.shared.loginWithKakaoTalk { _, error in
//            if let error {
//                self.error = error
//            } else {
//                self.getKakaoUserDetail()
//            }
//        }
//    } else {
//        UserApi.shared.loginWithKakaoAccount { _, error in
//            if let error {
//                self.error = error
//            } else {
//                self.getKakaoUserDetail()
//            }
//        }
//    }
//}
//
//private func handleKakaoLogout() {
//    UserApi.shared.logout {(error) in
//        if let error = error {
//            self.error = error
//        }
//        else {
//            self.user = nil
//            self.error = nil
//            self.isLoggedIn  = false
//        }
//    }
//}
//
//private func getKakaoUserDetail() {
//    UserApi.shared.me() { user, error in
//        if let error {
//            self.error = error
//        }
//        if let name = user?.kakaoAccount?.profile?.nickname,
//           let email = user?.kakaoAccount?.email {
//            do {
//                if let userData = try self.getUserData(email: email, type: .kakao) {
//                    self.user = userData
//                } else {
//                    self.addUser(name: name,
//                                 email: email,
//                                 type: OAuthType.kakao)
//                }
//                UserDefaults.standard.setValue(OAuthType.kakao.rawValue, forKey: "latestOAuthType")
//                self.isLoggedIn = true
//            } catch(let error) {
//                self.error = error
//            }
//        }
//    }
//}
//
//private func handleGoogleLogin() {
//    guard let presentingViewController = (UIApplication.shared.connectedScenes.first
//                                          as? UIWindowScene)?.windows.first?.rootViewController else { return }
//
//    GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
//        if let error {
//            self.error = error
//        }
//        if let result,
//           let profile = result.user.profile {
//            self.getGoogleUserDetail(profile: profile)
//        }
//    }
//}
//
//private func getGoogleUserDetail(profile: GIDProfileData) {
//    do {
//        if let userData = try self.getUserData(email: profile.email, type: .google) {
//            self.user = userData
//        } else {
//            self.addUser(name: profile.name,
//                         email: profile.email,
//                         type: OAuthType.google)
//        }
//        UserDefaults.standard.setValue(OAuthType.google.rawValue, forKey: "latestOAuthType")
//        self.isLoggedIn = true
//    } catch(let error) {
//        self.error = error
//    }
//}
//
//private func handleGoogleLogout() {
//    GIDSignIn.sharedInstance.signOut()
//    self.user = nil
//    self.error = nil
//    self.isLoggedIn  = false
//}
//
//private func getUserData(email: String, type: OAuthType) throws -> UserDTO? {
//    let allUsers: [UserDTO] = try DecodingManager.shared.loadFile("test_user.json")
//    let filtered = allUsers.filter { $0.email == email && $0.oAuthType == type }
//    guard let user = filtered.first else { return nil }
//    return user
//}
//
//private func addUser(name: String, email: String, type: OAuthType) {
//    // TODO: 새 유저 만들기
//    self.user = UserDTO(
//        id: UUID(),
//        name: name,
//        email: email,
//        oAuthType: type
//    )
//}
