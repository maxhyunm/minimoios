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
    @EnvironmentObject var authViewModel: KakaoAuthViewModel
    
    var body: some View {
        if authViewModel.isLogin {
            Button {
                authViewModel.handleLogout()
            } label: {
                Text("LogOut")
            }
            
        } else {
            LoginView()
                .environmentObject(authViewModel)
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
