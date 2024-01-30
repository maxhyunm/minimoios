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
            if let latestOAuthType = UserDefaults.standard.object(forKey: "latestOAuthType") as? String {
                Text("\(latestOAuthType) Logged In")
            } else {
                Text("Logged In")
            }
            Spacer()
            Menu {
                Text("정보 수정")
                
                Button {
                    authModel.handleLogout()
                } label: {
                    Text("로그아웃")
                        .font(.headline)
                }
            } label: {
                Image(systemName: "person.crop.circle")
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
