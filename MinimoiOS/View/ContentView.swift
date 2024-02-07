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
                let minimoModel = MinimoModel(userId: userModel.user.id,
                                              contentsOwnerId: userModel.user.id,
                                              firebaseManager: authManager.firebaseManager)
                TabMainView(minimoModel: minimoModel, logOutTrigger: $logOutTrigger)
                    .environmentObject(userModel)
                    .onChange(of: logOutTrigger) { state in
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
