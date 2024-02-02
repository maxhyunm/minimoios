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
    @Binding var fetchTrigger: Bool
    @Binding var tabType: TabType
    let userId: String
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ProfileList(fetchTrigger: $fetchTrigger, tabType: tabType)
                .environmentObject(viewModel)
            
            if userId == viewModel.user.id.uuidString {
                let writeViewModel = WriteViewModel(user: viewModel.user, firebaseManager: viewModel.firebaseManager)
                WriteButton(isWriting: $isWriting, fetchTrigger: $fetchTrigger, writeViewModel: writeViewModel)
            }
        }
        .navigationTitle(tabType.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ProfileMainView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMainView(fetchTrigger: .constant(false),
                        tabType: .constant(.home),
                        userId: "c8ad784e-a52a-4914-9aec-e115a2143b87")
        .environmentObject(PreviewStatics.profileViewModel)
    }
}
