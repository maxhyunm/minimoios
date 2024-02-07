//
//  ProfileMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/02.
//

import SwiftUI

struct ProfileMainView: View {
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var ownerModel: UserModel
    @EnvironmentObject var viewModel: MinimoModel
    @EnvironmentObject var writeViewModel: WriteViewModel
    @State private var isWriting: Bool = false
    @Binding var fetchTrigger: Bool
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ProfileList(fetchTrigger: $fetchTrigger)
                    .environmentObject(userModel)
                    .environmentObject(ownerModel)
                    .environmentObject(viewModel)
                
                if ownerModel.user.id == userModel.user.id {
                    WriteButton(isWriting: $isWriting, fetchTrigger: $fetchTrigger, writeViewModel: writeViewModel)
                }
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
            .toolbarBackground(TabType.profile.navigationBarBackground, for: .navigationBar)
            
        }
    }
}

struct ProfileMainView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMainView(fetchTrigger: .constant(false))
            .environmentObject(PreviewStatics.userModel)
            .environmentObject((PreviewStatics.userModel))
            .environmentObject(PreviewStatics.profileViewModel)
    }
}
