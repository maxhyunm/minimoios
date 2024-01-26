//
//  ContentView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/26.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

struct ContentView: View {
    @EnvironmentObject var kakaoAuth: KakaoAuthViewModel
    
    var body: some View {
        if kakaoAuth.isLogin {
            Button {
                kakaoAuth.logoutWithKakao()
            } label: {
                Text("LogOut")
            }

        } else {
            LoginView()
                .environmentObject(kakaoAuth)
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(KakaoAuthViewModel())
    }
}
