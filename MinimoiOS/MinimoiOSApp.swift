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
import FirebaseCore
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
//      if FirebaseApp.app() == nil {
//        FirebaseApp.configure()
//      }

    return true
  }
}

@main
struct MinimoiOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @State private var authManager = AuthManager(firebaseManager: FirebaseManager())
    
    init() {
        guard let nativeKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String else { return }
        KakaoSDK.initSDK(appKey: nativeKey)
    }
    
    var body: some Scene {
        WindowGroup {
            let authManager = AuthManager(firebaseManager: FirebaseManager())
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
                .onAppear {
                    authManager.checkLogin()
                }
                .environmentObject(authManager)
        }
    }
}
