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
    @State private var isEditInformationVisible: Bool = false
    @Binding var logOutTrigger: Bool
    
    var body: some View {
        NavigationStack {
        Text("Empty")
            .navigationTitle(TabType.search.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarMenuView(editInformationTrigger: $isEditInformationVisible, logOutTrigger: $logOutTrigger)
            }
            .tint(.cyan)
            .toolbarBackground(TabType.search.navigationBarBackground, for: .navigationBar)
            .sheet(isPresented: $isEditInformationVisible) {
                EditInformationView(name: userModel.user.name,
                                    isVisible: $isEditInformationVisible,
                                    fetchTrigger: $fetchTrigger)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(
            fetchTrigger: .constant(false),
            logOutTrigger: .constant(false))
    }
}
