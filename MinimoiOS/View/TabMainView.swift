//
//  TabMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import SwiftUI

struct TabMainView: View {
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State private var isEditProfileVisible: Bool = false
    @State private var fetchTrigger: Bool = true
    @State private var tabType: TabType = .home
    @Binding var logOutTrigger: Bool
    
//    private var isScrollOnTop: Bool {
//        minimoViewModel.newScrollOffset >= minimoViewModel.originScrollOffset + 10.0
//    }
    
    init(logOutTrigger: Binding<Bool>) {
        _logOutTrigger = logOutTrigger
    }
    
    var body: some View {
        VStack {
            NavigationStack() {
                ZStack {
                    switch tabType {
                    case .home:
                        HomeMainView(fetchTrigger: $fetchTrigger)
                            .environmentObject(userModel)
                            .environmentObject(homeViewModel)
                    case .profile:
                        ProfileMainView(fetchTrigger: $fetchTrigger)
                            .environmentObject(userModel)
                            .environmentObject(profileViewModel)
                    case .search:
                        SearchView()
                    }
                }
                .onChange(of: fetchTrigger) { _ in
                    switch tabType {
                    case .home:
                        homeViewModel.fetchContents(followings: userModel.followings)
                    case .profile:
                        profileViewModel.fetchContents()
                    case .search:
                        break
                    }
                }
                .toolbar {
                    ToolbarItemView(isEditProfileVisible: $isEditProfileVisible, logOutTrigger: $logOutTrigger)
                }
                .tint(.cyan)
                .toolbarBackground(tabType.navigationBarBackground, for: .navigationBar)
                .navigationTitle(tabType == .search ? tabType.title : "")
                .sheet(isPresented: $isEditProfileVisible) {
                    EditInformationView(name: $userModel.user.name,
                                        isProfileVisible: $isEditProfileVisible,
                                        fetchTrigger: $fetchTrigger)
                    .environmentObject(userModel)
                }
            }
            TabItemsView(tabType: $tabType)
                .frame(height: 30)
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TabMainView(logOutTrigger: .constant(false))
            .environmentObject(PreviewStatics.homeViewModel)
            .environmentObject(PreviewStatics.profileViewModel)
            .environmentObject(PreviewStatics.editInformationViewModel)
    }
}
