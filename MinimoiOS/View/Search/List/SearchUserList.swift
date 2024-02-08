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
    
    var body: some View {
        if !viewModel.isLoading && viewModel.users.isEmpty {
            VStack {
                Text("No User Results")
            }
            .frame(maxHeight: .infinity)
        } else {
            ScrollView {
                LazyVStack  {
                    ForEach($viewModel.users, id: \.self) { $user in
                        let targetUserModel = UserModel(user: user, firebaseManager: viewModel.firebaseManager)
                        SearchUserRow(targetUser: $user, targetUserModel: targetUserModel)
                            .listRowSeparator(.hidden)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct SearchUserList_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserList(viewModel: PreviewStatics.searchViewModel)
    }
}
