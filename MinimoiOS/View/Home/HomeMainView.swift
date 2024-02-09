//
//  MinimoMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct HomeMainView: View {
    @Environment(\.colorScheme) var colorScheme
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
                    Task {
                        await userModel.fetchFollowers()
                        await userModel.fetchFollowings()
                        viewModel.followings = userModel.followings
                        viewModel.fetchContents()
                    }
                }
                .toolbar {
                    BasicToolBarView(editInformationTrigger: $isEditInformationVisible)
                }
                .tint(Colors.highlight(for: colorScheme))
                .toolbarBackground(Colors.background(for: colorScheme), for: .navigationBar)
                .sheet(isPresented: $isEditInformationVisible) {
                    EditInformationView(name: userModel.user.name,
                                        biography: userModel.user.biography,
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
                    .background(Colors.background(for: colorScheme).opacity(0.5))
            }
        }
    }
}

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView(viewModel: PreviewStatics.homeViewModel)
    }
}
