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
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        if userViewModel.isLoggedIn {
            Button {
                userViewModel.handleLogout()
            } label: {
                Text("LogOut")
            }
            
        } else {
            LoginView()
                .environmentObject(userViewModel)
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
        ContentView().environmentObject(UserViewModel(user: UserModel(
            token: "", name: "", email: "", oAuthType: .unknown
        )))
    }
}
