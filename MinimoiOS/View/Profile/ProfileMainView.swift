//
//  ProfileMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/02.
//

import SwiftUI

struct ProfileMainView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @State private var isWriting: Bool = false
    @Binding var user: UserDTO
    @Binding var fetchTrigger: Bool
    @Binding var tabType: TabType
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ProfileList(user: $user, fetchTrigger: $fetchTrigger, tabType: tabType)
                .environmentObject(viewModel)
            
            if viewModel.profileOwnerId == user.id {
                let writeViewModel = WriteViewModel(userId: user.id, firebaseManager: viewModel.firebaseManager)
                WriteButton(isWriting: $isWriting, fetchTrigger: $fetchTrigger, writeViewModel: writeViewModel)
            }
        }
        .navigationTitle(tabType.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ProfileMainView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMainView(user: .constant(PreviewStatics.user),
                        fetchTrigger: .constant(false),
                        tabType: .constant(.home))
        .environmentObject(PreviewStatics.profileViewModel)
    }
}
