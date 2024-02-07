//
//  MinimoMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct HomeMainView: View {
    @EnvironmentObject var userModel: UserModel
    @ObservedObject var viewModel: MinimoModel
    @State private var isWriting: Bool = false
    @State private var isEditInformationVisible: Bool = false
    @Binding var fetchTrigger: Bool
    @Binding var logOutTrigger: Bool
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                HomeList(viewModel: viewModel,
                         fetchTrigger: $fetchTrigger)
                WriteButton(viewModel: viewModel,
                            isWriting: $isWriting,
                            fetchTrigger: $fetchTrigger)
            }
            .onAppear {
                userModel.fetchFollowers()
                userModel.fetchFollowings()
                fetchTrigger.toggle()
            }
            .onChange(of: userModel.followings) { followings in
                viewModel.fetchFollowingContents(followings: followings)
            }
            .toolbar {
                ToolbarMenuView(editInformationTrigger: $isEditInformationVisible, logOutTrigger: $logOutTrigger)
            }
            .tint(.cyan)
            .toolbarBackground(TabType.home.navigationBarBackground, for: .navigationBar)
            .sheet(isPresented: $isEditInformationVisible) {
                EditInformationView(name: userModel.user.name,
                                    isVisible: $isEditInformationVisible,
                                    fetchTrigger: $fetchTrigger)
            }
        }
    }
}

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView(viewModel: PreviewStatics.minimoModel,
                     fetchTrigger: .constant(false),
                     logOutTrigger: .constant(false))
    }
}
