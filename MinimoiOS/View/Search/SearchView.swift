//
//  SearchView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userModel: UserModel
    @ObservedObject var viewModel: SearchViewModel
    @State private var isEditInformationVisible: Bool = false
    @State private var searchText: String = ""
    @State private var tabType: SearchTab = .contents
    @State private var isSearched: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    HStack {
                        TextField("Search", text: $searchText)
                            .submitLabel(.done)
                            .padding(10)
                            .background(Colors.minimoRow(for: colorScheme))
                            .cornerRadius(15)
                        Button {
                            isSearched = true
                            viewModel.searchContents(for: searchText)
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    
                    VStack {
                        if isSearched {
                            SearchTabItemsView(tabType: $tabType, viewModel: viewModel)
                            
                            switch tabType {
                            case .contents:
                                SearchContentList(viewModel: viewModel)
                                    
                            case .users:
                                SearchUserList(viewModel: viewModel)
                            }
                        }
                    }
                    .frame(maxHeight: .infinity)
                    
                }
                .toolbar {
                    BasicToolBarView(editInformationTrigger: $isEditInformationVisible)
                }
                .tint(Colors.highlight(for: colorScheme))
                .toolbarBackground(Colors.background(for: colorScheme), for: .navigationBar)
                .sheet(isPresented: $isEditInformationVisible) {
                    EditInformationView(name: userModel.user.name,
                                        biography: userModel.user.biography,
                                        isVisible: $isEditInformationVisible)
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .progressViewStyle(CircularProgressViewStyle())
                    .controlSize(.large)
                    .background(Colors.background(for: colorScheme).opacity(0.5))
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: PreviewStatics.searchViewModel)
    }
}
