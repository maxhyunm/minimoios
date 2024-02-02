//
//  TabMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import SwiftUI

struct TabMainView: View {
    @EnvironmentObject var authModel: AuthModel
    @EnvironmentObject var minimoViewModel: MinimoViewModel
    @EnvironmentObject var editProfileViewModel: EditProfileViewModel
    @State private var isEditProfileVisible: Bool = false
    @State private var tabType: TabType = .home
    private var isScrollOnTop: Bool {
        minimoViewModel.newScrollOffset >= minimoViewModel.originScrollOffset + 10.0
    }
    
    var body: some View {
        NavigationView {
            TabView {
                MinimoMainView(tabType: $tabType)
                    .environmentObject(minimoViewModel)
                    .tabItem {
                        Label(tabType.title, systemImage: "house.fill")
                    }
                    .onAppear {
                        tabType = .home
                    }
                MinimoMainView(tabType: $tabType)
                    .environmentObject(minimoViewModel)
                    .tabItem {
                        Label(tabType.title, systemImage: "person.fill")
                    }
                    .onAppear {
                        tabType = .profile
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
                            authModel.handleLogout()
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
            .navigationBarHidden(tabType == .profile)
//            .navigationBarHidden(!isScrollOnTop)
        }
        .sheet(isPresented: $isEditProfileVisible) {
            EditProfileView(isProfileVisible: $isEditProfileVisible)
                .environmentObject(editProfileViewModel)
                .onDisappear {
                    minimoViewModel.fetchContents(for: tabType)
                }
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TabMainView()
            .environmentObject(AuthModel(firebaseManager: FirebaseManager()))
            .environmentObject(
                MinimoViewModel(
                    user: UserDTO(
                        id: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                        name: "테스트"
                    ),
                    firebaseManager: FirebaseManager()))
    }
}
