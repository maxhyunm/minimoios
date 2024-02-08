//
//  ProfileSearchView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/08.
//

import SwiftUI

struct ProfileSearchView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State var isSearching: Bool = false
    @State var searchText: String = ""
    
    var buttonName: String {
        isSearching ? "xmark" : "magnifyingglass"
    }
    
    var body: some View {
        HStack(spacing: 10) {
            if isSearching {
                TextField("Search", text: $searchText)
                    .submitLabel(.done)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .frame(height: 40)
                    .background(Color(white: 0.95).opacity(0.5))
                    .cornerRadius(15)
                    .onChange(of: searchText) { text in
                        viewModel.searchContent(keyword: text)
                    }
            } else {
                Spacer()
            }
            Button {
                isSearching.toggle()
                
            } label: {
                Image(systemName: buttonName)
                    .resizable()
                    .tint(.cyan)
                    .padding(5)
                    .background(.white.opacity(0.7))
                    .frame(width: 25, height: 25)
                    .clipShape(Circle())
                    .frame(height: 40)
            }
        }
        .frame(maxWidth: .infinity)
        .onChange(of: isSearching) { searching in
            if !searching {
                viewModel.fetchContents()
            }
        }
    }
}

struct ProfileSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSearchView(viewModel: PreviewStatics.profileViewModel)
    }
}
