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
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                loginViewModel.handleLogin(for: .kakao)
            } label : {
                Image("kakao_login_large_wide")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width : UIScreen.main.bounds.width * 0.9)
            }
            
            GoogleSignInButton(scheme: .light, style: .wide) {
                loginViewModel.handleLogin(for: .google)
            }
            .frame(width : UIScreen.main.bounds.width * 0.9, height: 60, alignment: .center)
        }
        .navigationDestination(isPresented: $loginViewModel.isLoggedIn) {
            Text("Logged In")
        }
        .onAppear {
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginViewModel())
    }
}
