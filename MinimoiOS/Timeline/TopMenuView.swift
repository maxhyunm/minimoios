//
//  TopMenuView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import SwiftUI

struct TopMenuView: View {
    @EnvironmentObject var authModel: AuthModel
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                authModel.handleLogout()
            } label: {
                if let latestOAuthType = UserDefaults.standard.object(forKey: "latestOAuthType") as? String {
                    Text("\(latestOAuthType) LogOut")
                } else {
                    Text("LogOut")
                }
            }
        }
        .padding()
    }
}

struct TopMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TopMenuView()
    }
}
