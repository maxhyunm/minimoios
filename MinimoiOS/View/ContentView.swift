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
    @EnvironmentObject var authManager: AuthManager
    @State private var logOutTrigger: Bool = false

    var body: some View {
        if authManager.isLoading {
            Text("M I N I M O")
        } else {
            if let userModel = authManager.userModel {
//                let homeViewModel = HomeViewModel(userId: userModel.user.id,
//                                                  firebaseManager: authManager.firebaseManager)
//                let profileViewModel = ProfileViewModel(ownerModel: userModel,
//                                                        firebaseManager: authManager.firebaseManager)
                let homeViewModel = MinimoModel(userId: userModel.user.id,
                                                firebaseManager: authManager.firebaseManager)
                let profileViewModel = MinimoModel(userId: userModel.user.id,
                                                   firebaseManager: authManager.firebaseManager)
                let writeViewModel = WriteViewModel(userId: userModel.user.id, firebaseManager: authManager.firebaseManager)
                TabMainView(logOutTrigger: $logOutTrigger)
                    .environmentObject(userModel)
                    .environmentObject(homeViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(writeViewModel)
                    .onChange(of: logOutTrigger) { state in
                        authManager.handleLogout()
                    }
            } else {
                LoginView()
                    .environmentObject(authManager)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthManager(firebaseManager: FirebaseManager()))
    }
}
