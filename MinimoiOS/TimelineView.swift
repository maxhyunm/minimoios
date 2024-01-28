//
//  TimelineView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/27.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        Button {
            loginViewModel.handleLogout()
        } label: {
            if let latestOAuthType = UserDefaults.standard.object(forKey: "latestOAuthType") as? String {
                Text("\(latestOAuthType) LogOut")
            } else {
                Text("LogOut")
            }
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView().environmentObject(LoginViewModel())
    }
}
