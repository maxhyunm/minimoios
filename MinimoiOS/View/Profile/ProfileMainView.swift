//
//  ProfileMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/02.
//

import SwiftUI

struct ProfileMainView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var tabType: Tab
    @ObservedObject var viewModel: ProfileViewModel
    @ObservedObject var ownerModel: UserModel
//    @State private var isWriting: Bool = false
    
    
    var body: some View {
        ZStack(alignment: .center) {
            NavigationStack {
                ZStack(alignment: .top) {
                    ProfileList(viewModel: viewModel,
                                ownerModel: ownerModel)
                    
                    ProfileSearchView(viewModel: viewModel)
                        .padding(.horizontal, 15)
                    
//                if ownerModel.user.id == userModel.user.id {
//                    WriteButton(viewModel: viewModel,
//                                isWriting: $isWriting)
//                }
                }
                .onAppear {
                    Task {
                        await ownerModel.fetchFollowers()
                        await ownerModel.fetchFollowings()
                        viewModel.fetchContents()
                    }
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
        .onChange(of: tabType.isNavigating) { isNavigating in
            if !isNavigating {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationBarHidden(true)
    }
}

struct ProfileMainView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMainView(viewModel: PreviewStatics.profileViewModel,
                        ownerModel: PreviewStatics.userModel)
    }
}
