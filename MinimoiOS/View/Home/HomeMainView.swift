//
//  MinimoMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct HomeMainView: View {
    @EnvironmentObject var userModel: UserModel
    @ObservedObject var viewModel: HomeViewModel
    @State private var isWriting: Bool = false
    @State private var isEditInformationVisible: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    HomeList(viewModel: viewModel)
                    WriteButton(viewModel: viewModel,
                                isWriting: $isWriting)
                }
                .onAppear {
                    userModel.fetchFollowers()
                    userModel.fetchFollowings()
                    viewModel.followings = userModel.followings
                    viewModel.fetchContents()
                }
                .toolbar {
                    ToolbarMenuView(editInformationTrigger: $isEditInformationVisible)
                }
                .tint(.cyan)
                .toolbarBackground(Tab.TabType.home.navigationBarBackground, for: .navigationBar)
                .sheet(isPresented: $isEditInformationVisible) {
                    EditInformationView(name: userModel.user.name,
                                        isVisible: $isEditInformationVisible)
                    .onDisappear {
                        viewModel.fetchContents()
                    }
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

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView(viewModel: PreviewStatics.homeViewModel)
    }
}
