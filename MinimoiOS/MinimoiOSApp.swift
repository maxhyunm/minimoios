//
//  MinimoiOSApp.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/26.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn

@main
struct MinimoiOSApp: App {
    @State private var userViewModel = UserViewModel(user: UserModel(token: "", name: "", email: "", oAuthType: .unknown))
    
    init() {
        guard let nativeKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String else { return }
        KakaoSDK.initSDK(appKey: nativeKey)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                .onAppear {
                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//                        if let error {
//
//                        }
                        if let user,
                           let userName = user.profile?.name,
                           let userEmail = user.profile?.email {
                            self.userViewModel.user.token = "\(user.accessToken)"
                            self.userViewModel.user.name = userName
                            self.userViewModel.user.email = userEmail
                            self.userViewModel.user.oAuthType = .google
                            self.userViewModel.isLoggedIn = true
                        }
                    }
                }
                .environmentObject(userViewModel)
        }
    }
}
