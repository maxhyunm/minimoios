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
    @Binding var fetchTrigger: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    ProfileList(viewModel: viewModel,
                                ownerModel: ownerModel,
                                fetchTrigger: $fetchTrigger)
                    
                    //                if ownerModel.user.id == userModel.user.id {
                    //                    WriteButton(viewModel: viewModel,
                    //                                isWriting: $isWriting,
                    //                                fetchTrigger: $fetchTrigger)
                    //                }
                }
                .onAppear {
                    ownerModel.fetchFollowers()
                    ownerModel.fetchFollowings()
                    fetchTrigger.toggle()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            SearchFromUserView(fetchTrigger: $fetchTrigger)
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
                    .progressViewStyle(CircularProgressViewStyle())
                    .controlSize(.large)
            }
        }
    }
}

struct ProfileMainView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMainView(viewModel: PreviewStatics.profileViewModel,
                        ownerModel: PreviewStatics.userModel,
                        fetchTrigger: .constant(false))
    }
}
