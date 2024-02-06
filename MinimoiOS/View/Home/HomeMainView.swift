//
//  MinimoMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct HomeMainView: View {
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var isWriting: Bool = false
    @Binding var fetchTrigger: Bool
    
    var body: some View {
        let writeViewModel = WriteViewModel(userId: viewModel.userId, firebaseManager: viewModel.firebaseManager)
        ZStack(alignment: .bottomTrailing) {
            HomeList(fetchTrigger: $fetchTrigger)
                .environmentObject(viewModel)
            WriteButton(isWriting: $isWriting, fetchTrigger: $fetchTrigger, writeViewModel: writeViewModel)
        }
        .onAppear {
            userModel.fetchFollowers()
            userModel.fetchFollowings()
            fetchTrigger.toggle()
        }
        .onChange(of: userModel.followings) { followings in
            viewModel.fetchContents(followings: followings)
        }
    }
}

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView(fetchTrigger: .constant(false))
        .environmentObject(PreviewStatics.homeViewModel)
    }
}
