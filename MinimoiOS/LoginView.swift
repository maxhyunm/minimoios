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

struct LoginView: View {
    @EnvironmentObject var kakaoAuth: KakaoAuthViewModel
    
    var body: some View {
        Button {
            kakaoAuth.loginWithKakao()

        } label : {
            Image("kakao_login_large_wide")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width : UIScreen.main.bounds.width * 0.9)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(KakaoAuthViewModel())
    }
}
