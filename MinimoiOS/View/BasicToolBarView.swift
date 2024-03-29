//
//  ToolBarITemView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/07.
//

import SwiftUI

struct BasicToolBarView: ToolbarContent {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authManager: AuthManager
    @Binding var editInformationTrigger: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Button {
                    editInformationTrigger = true
                } label: {
                    Text("정보 수정")
                        .font(.body)
                }
                
                Button {
                    authManager.handleLogout()
                } label: {
                    Text("로그아웃")
                        .font(.headline)
                }
                
            } label: {
                Image(systemName: "person.circle")
            }
            .foregroundColor(Colors.highlight(for: colorScheme))
        }
    }
}

