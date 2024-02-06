//
//  ProfileMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/02.
//

import SwiftUI

struct ProfileMainView: View {
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var viewModel: ProfileViewModel
    @State private var isWriting: Bool = false
    @Binding var fetchTrigger: Bool
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ProfileList(fetchTrigger: $fetchTrigger)
                .environmentObject(userModel)
                .environmentObject(viewModel)
            
            if viewModel.ownerModel.user.id == userModel.user.id {
                let writeViewModel = WriteViewModel(userId: userModel.user.id, firebaseManager: viewModel.firebaseManager)
                WriteButton(isWriting: $isWriting, fetchTrigger: $fetchTrigger, writeViewModel: writeViewModel)
            }
        }
        .onAppear {
            viewModel.ownerModel.fetchFollowers()
            viewModel.ownerModel.fetchFollowings()
            fetchTrigger.toggle()
        }
    }
}

struct ProfileMainView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMainView(fetchTrigger: .constant(false))
            .environmentObject(PreviewStatics.userModel)
            .environmentObject(PreviewStatics.profileViewModel)
    }
}
