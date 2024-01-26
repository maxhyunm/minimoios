//
//  LoginView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/26.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import Combine
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                userViewModel.user.oAuthType = .kakao
                userViewModel.handleLogin()
            } label : {
                Image("kakao_login_large_wide")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width : UIScreen.main.bounds.width * 0.9)
            }
            
            GoogleSignInButton(scheme: .light, style: .wide) {
                userViewModel.user.oAuthType = .google
                userViewModel.handleLogin()
            }
            .frame(width : UIScreen.main.bounds.width * 0.9, height: 60, alignment: .center)
        }
        .navigationDestination(isPresented: $userViewModel.isLoggedIn) {
            Text("Logged In")
        }
        .onAppear {
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserViewModel(user: UserModel(
                token: "", name: "", email: "", oAuthType: .unknown
            )))
    }
}
