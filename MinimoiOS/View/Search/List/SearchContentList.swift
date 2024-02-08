//
//  SearchContentList.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/08.
//

import SwiftUI

struct SearchContentList: View {
    @EnvironmentObject var userModel: UserModel
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        ScrollView {
            List($viewModel.contents) { $content in
                let minimoRowViewModel = MinimoRowViewModel(
                    content: content,
                    firebaseManager: viewModel.firebaseManager,
                    userId: userModel.user.id.uuidString
                )
                SearchContentRow(viewModel: minimoRowViewModel)
                    .listRowSeparator(.hidden)
            }
            .padding(.horizontal)
            
        }
    }
}

struct SearchContentList_Previews: PreviewProvider {
    static var previews: some View {
        SearchContentList(viewModel: PreviewStatics.searchViewModel)
    }
}
