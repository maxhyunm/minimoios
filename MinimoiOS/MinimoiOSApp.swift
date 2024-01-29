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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      if FirebaseApp.app() == nil {
        FirebaseApp.configure()
      }

    return true
  }
}

@main
struct MinimoiOSApp: App {
    @State private var authModel = AuthModel(firebaseManager: FirebaseManager())
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        guard let nativeKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String else { return }
        KakaoSDK.initSDK(appKey: nativeKey)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
                .environmentObject(authModel)
        }
    }
}
