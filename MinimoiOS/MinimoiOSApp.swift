//
//  MinimoiOSApp.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/26.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct MinimoiOSApp: App {
    @State private var userToken: String = ""
    
    init() {
        guard let nativeKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String else { return }
        KakaoSDK.initSDK(appKey: nativeKey)
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
