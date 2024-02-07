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
    @State private var tabType: Tab = Tab()

    var body: some View {
        if authManager.isLoading {
            Text("M I N I M O")
        } else {
            if let userModel = authManager.userModel {
                let homeModel = HomeViewModel(userId: userModel.user.id,
                                              followings: userModel.followings,
                                              firebaseManager: authManager.firebaseManager)
                let profileModel = ProfileViewModel(ownerId: userModel.user.id,
                                                    firebaseManager: authManager.firebaseManager)
//                let minimoModel = MinimoModel(userId: userModel.user.id,
//                                              contentsOwnerId: userModel.user.id,
//                                              firebaseManager: authManager.firebaseManager)
//                TabMainView(minimoModel: minimoModel)
                TabMainView(homeModel: homeModel, profileModel: profileModel)
                    .environmentObject(userModel)
                    .environmentObject(tabType)
                    .onChange(of: authManager.logOutTrigger) { state in
                        authManager.handleLogout()
                    }
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
