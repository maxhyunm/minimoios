//
//  SearchView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var userModel: UserModel
    @ObservedObject var viewModel: SearchViewModel
    @Binding var fetchTrigger: Bool
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
                            .background(Color(white: 0.95))
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
                    ToolbarMenuView(editInformationTrigger: $isEditInformationVisible)
                }
                .tint(.cyan)
                .toolbarBackground(Tab.TabType.search.navigationBarBackground, for: .navigationBar)
                .sheet(isPresented: $isEditInformationVisible) {
                    EditInformationView(name: userModel.user.name,
                                        isVisible: $isEditInformationVisible,
                                        fetchTrigger: $fetchTrigger)
                }
            }
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .progressViewStyle(CircularProgressViewStyle())
                    .controlSize(.large)
                    .background(.white.opacity(0.5))
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: PreviewStatics.searchViewModel,
            fetchTrigger: .constant(false))
    }
}
