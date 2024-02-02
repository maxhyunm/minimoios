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
    @EnvironmentObject var authModel: AuthManager
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                authModel.handleLogin(for: .kakao)

            } label : {
                Image("kakao_login_large_wide")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width : UIScreen.main.bounds.width * 0.9)
            }
            
            GoogleSignInButton(scheme: .light, style: .wide) {
                authModel.handleLogin(for: .google)
            }
            .frame(width : UIScreen.main.bounds.width * 0.9, height: 60, alignment: .center)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthManager(firebaseManager: FirebaseManager()))
    }
}
