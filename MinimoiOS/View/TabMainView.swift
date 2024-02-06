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
    @EnvironmentObject var editInformationViewModel: EditInformationViewModel
    @State private var isEditProfileVisible: Bool = false
    @State private var tabType: TabType = .home
    @State private var fetchTrigger: Bool = true
    @Binding var logOutTrigger: Bool
    
//    private var isScrollOnTop: Bool {
//        minimoViewModel.newScrollOffset >= minimoViewModel.originScrollOffset + 10.0
//    }
    
    init(logOutTrigger: Binding<Bool>) {
        _logOutTrigger = logOutTrigger
    }
    
    var body: some View {
        NavigationView {
            TabView {
                HomeMainView(fetchTrigger: $fetchTrigger,
                             tabType: $tabType)
                    .environmentObject(homeViewModel)
                    .tabItem {
                        Label(tabType.title, systemImage: "house.fill")
                    }
                    .onAppear {
                        tabType = .home
                        fetchTrigger.toggle()
                    }
                ProfileMainView(fetchTrigger: $fetchTrigger,
                                tabType: $tabType)
                    .environmentObject(userModel)
                    .environmentObject(profileViewModel)
                    .tabItem {
                        Label(tabType.title, systemImage: "person.fill")
                    }
                    .onAppear {
                        tabType = .profile
                        fetchTrigger.toggle()
                    }
                SearchView(tabType: $tabType)
                    .tabItem {
                        Label(tabType.title, systemImage: "magnifyingglass")
                    }
                    .onAppear {
                        tabType = .search
                    }
            }
            .labelStyle(.iconOnly)
            .navigationTitle(tabType == .search ? tabType.title : "")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            isEditProfileVisible = true
                        } label: {
                            Text("정보 수정")
                                .font(.body)
                        }
                        
                        Button {
                            logOutTrigger.toggle()
                        } label: {
                            Text("로그아웃")
                                .font(.headline)
                        }
                        
                    } label: {
                        Image(systemName: "person.circle")
                    }
                    .foregroundColor(.cyan)
                }
            }
            .tint(.cyan)
            .toolbarBackground(tabType.navigationBarBackground, for: .navigationBar)
//            .navigationBarHidden(tabType == .profile)
//            .navigationBarHidden(!isScrollOnTop)
        }
        .sheet(isPresented: $isEditProfileVisible) {
            EditInformationView(name: $userModel.user.name,
                                isProfileVisible: $isEditProfileVisible,
                                fetchTrigger: $fetchTrigger)
            .environmentObject(editInformationViewModel)
        }
        .onChange(of: fetchTrigger) { _ in
            switch tabType {
            case .home:
                homeViewModel.fetchContents()
            case .profile:
                profileViewModel.fetchContents()
            case .search:
                return
            }
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
