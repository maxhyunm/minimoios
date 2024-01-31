//
//  ContentView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/26.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import Combine

struct ContentView: View {
    @EnvironmentObject var authModel: AuthModel
    
    var body: some View {
        if authModel.isLoading {
            Text("M I N I M O")
        } else {
            if let user = authModel.user {
                let minimoViewModel = MinimoViewModel(user: user, firebaseManager: authModel.firebaseManager)
                let editProfileViewModel = EditProfileViewModel(user: user, firebaseManager: authModel.firebaseManager)
                
                TabMainView()
                    .environmentObject(authModel)
                    .environmentObject(minimoViewModel)
                    .environmentObject(editProfileViewModel)
            } else {
                LoginView()
                    .environmentObject(authModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthModel(firebaseManager: FirebaseManager()))
    }
}
