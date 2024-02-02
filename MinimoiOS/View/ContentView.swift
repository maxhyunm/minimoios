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
            if let user = authManager.user {
                let homeViewModel = HomeViewModel(user: user, firebaseManager: authManager.firebaseManager)
                let profileViewModel = ProfileViewModel(user: user,
                                                        profileOwnerId: user.id,
                                                        firebaseManager: authManager.firebaseManager)
                
                TabMainView(logOutTrigger: $logOutTrigger)
                    .environmentObject(homeViewModel)
                    .environmentObject(profileViewModel)
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
