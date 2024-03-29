//
//  SearchUserList.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/08.
//

import SwiftUI

struct SearchUserList: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var tabType: Tab
    @ObservedObject var viewModel: SearchViewModel
    @State var rowColor: Color = .clear
    
    var body: some View {
        if !viewModel.isLoading && viewModel.users.isEmpty {
            VStack {
                Text("No User Results")
            }
            .frame(maxHeight: .infinity)
        } else {
            List($viewModel.users, id: \.self)  { $user in
                let targetUserModel = UserModel(user: user, firebaseManager: viewModel.firebaseManager)
                let profileViewModel = ProfileViewModel(
                    ownerId: user.id,
                    firebaseManager: targetUserModel.firebaseManager
                )
                NavigationLink {
                    ProfileMainView(viewModel: profileViewModel,
                                    ownerModel: targetUserModel)
                    .onAppear {
                        tabType.isNavigating = true
                    }
                } label: {
                    SearchUserRow(targetUser: $user)
                        .background(rowColor)
                }
                .tint(Colors.basic(for: colorScheme))
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }
}

struct SearchUserList_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserList(viewModel: PreviewStatics.searchViewModel)
    }
}
