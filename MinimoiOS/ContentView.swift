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
        if let user = authModel.user {
            let timelineViewModel = TimelineViewModel(user: user.id)
            TimelineList()
                .onAppear {
                    timelineViewModel.readTimeline()
                }
                .environmentObject(authModel)
                .environmentObject(timelineViewModel)
        } else {
            LoginView()
                .onAppear {
                    authModel.checkLogin()
                }
                .environmentObject(authModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthModel())
    }
}
