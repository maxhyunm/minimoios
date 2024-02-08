//
//  SearchUserList.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/08.
//

import SwiftUI

struct SearchUserList: View {
    @EnvironmentObject var userModel: UserModel
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
                } label: {
                    SearchUserRow(targetUser: $user)
                        .background(rowColor)
                }
                .tint(.black)
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
