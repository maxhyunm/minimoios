//
//  TopMenuView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import SwiftUI

struct TopMenuView: View {
    @EnvironmentObject var authModel: AuthModel
    @Binding var isProfileVisible: Bool
    
    var body: some View {
        HStack {
            Spacer()
            
            Menu {
                Button {
                    isProfileVisible = true
                } label: {
                    Text("정보 수정")
                        .font(.body)
                }
                
                Button {
                    authModel.handleLogout()
                } label: {
                    Text("로그아웃")
                        .font(.headline)
                }
                
            } label: {
                Image(systemName: "person.circle")
                    .resizable()
            }
            .foregroundColor(.cyan)
            .frame(width: 25, height: 25)
        }
        .padding(.trailing)
    }
}

struct TopMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TopMenuView(isProfileVisible: .constant(false))
            .environmentObject(AuthModel(firebaseManager: FirebaseManager()))
    }
}