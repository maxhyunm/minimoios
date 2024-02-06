//
//  SearchView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var userModel: UserModel
    @Binding var fetchTrigger: Bool
    @Binding var isEditProfileVisible: Bool
    @Binding var logOutTrigger: Bool
    
    var body: some View {
        NavigationStack {
        Text("Empty")
            .navigationTitle(TabType.search.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarMenuView(isEditProfileVisible: $isEditProfileVisible, logOutTrigger: $logOutTrigger)
            }
            .tint(.cyan)
            .toolbarBackground(TabType.search.navigationBarBackground, for: .navigationBar)
            .sheet(isPresented: $isEditProfileVisible) {
                EditInformationView(name: $userModel.user.name,
                                    isProfileVisible: $isEditProfileVisible,
                                    fetchTrigger: $fetchTrigger)
                .environmentObject(userModel)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(
            fetchTrigger: .constant(false),
            isEditProfileVisible: .constant(false),
            logOutTrigger: .constant(false))
        .environmentObject(PreviewStatics.userModel)
    }
}
