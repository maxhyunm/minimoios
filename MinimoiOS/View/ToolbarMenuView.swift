//
//  ToolBarITemView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/07.
//

import SwiftUI

struct ToolbarMenuView: ToolbarContent {
    @Binding var editInformationTrigger: Bool
    @Binding var logOutTrigger: Bool
    
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
                    logOutTrigger.toggle()
                } label: {
                    Text("로그아웃")
                        .font(.headline)
                }
                
            } label: {
                Image(systemName: "person.circle")
            }
            .foregroundColor(.cyan)
        }
    }
}
