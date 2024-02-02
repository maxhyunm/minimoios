//
//  TabMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import SwiftUI

struct TabMainView: View {
    @State private var isEditProfileVisible: Bool = false
    @State private var tabType: TabType = .home
    @State private var fetchTrigger: Bool = true
    @Binding var logOutTrigger: Bool
    let user: UserDTO
    let minimoViewModel: MinimoViewModel
    let editProfileViewModel: EditProfileViewModel
    
    private var isScrollOnTop: Bool {
        minimoViewModel.newScrollOffset >= minimoViewModel.originScrollOffset + 10.0
    }
    
    var body: some View {
        NavigationView {
            TabView {
                MinimoMainView(fetchTrigger: $fetchTrigger, tabType: $tabType)
                    .environmentObject(minimoViewModel)
                    .tabItem {
                        Label(tabType.title, systemImage: "house.fill")
                    }
                    .onAppear {
                        tabType = .home
                        fetchTrigger.toggle()
                    }
                MinimoMainView(fetchTrigger: $fetchTrigger, tabType: $tabType)
                    .environmentObject(minimoViewModel)
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
//            .toolbarBackground(tabType.navigationBarBackground, for: .navigationBar)
//            .navigationBarHidden(tabType == .profile)
//            .navigationBarHidden(!isScrollOnTop)
        }
        .sheet(isPresented: $isEditProfileVisible) {
            EditProfileView(isProfileVisible: $isEditProfileVisible, fetchTrigger: $fetchTrigger)
                .environmentObject(editProfileViewModel)
//                .onDisappear {
//                    minimoViewModel.fetchContents(for: tabType)
//                }
        }
        .onChange(of: fetchTrigger) { status in
            minimoViewModel.fetchContents(for: tabType)
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let user = UserDTO(
            id: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
            name: "테스트"
        )
        let firebaseManager = FirebaseManager()
        TabMainView(logOutTrigger: .constant(false),
                    user: user,
                    minimoViewModel:  MinimoViewModel(user: user, firebaseManager: firebaseManager),
                    editProfileViewModel: EditProfileViewModel(user: user, firebaseManager: firebaseManager)
        )
    }
}
