//
//  ProfileMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/02.
//

import SwiftUI

struct ProfileMainView: View {
    @EnvironmentObject var userModel: UserModel
    @ObservedObject var viewModel: ProfileViewModel
    @ObservedObject var ownerModel: UserModel
    @State private var isWriting: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    ProfileList(viewModel: viewModel,
                                ownerModel: ownerModel)
                    
//                if ownerModel.user.id == userModel.user.id {
//                    WriteButton(viewModel: viewModel,
//                                isWriting: $isWriting)
//                }
                }
                .onAppear {
                    ownerModel.fetchFollowers()
                    ownerModel.fetchFollowings()
                    viewModel.fetchContents()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            SearchFromUserView()
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .tint(.cyan)
                        }
                    }
                }
                .tint(.cyan)
                .toolbarBackground(Tab.TabType.profile.navigationBarBackground, for: .navigationBar)
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

struct ProfileMainView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMainView(viewModel: PreviewStatics.profileViewModel,
                        ownerModel: PreviewStatics.userModel)
    }
}
