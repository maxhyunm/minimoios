//
//  TimelineView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import SwiftUI

struct TabMainView: View {
    @EnvironmentObject var authModel: AuthModel
    @EnvironmentObject var minimoViewModel: MinimoViewModel
    @EnvironmentObject var editProfileViewModel: EditProfileViewModel
    @State private var isProfileVisible: Bool = false
    @State private var isPopUpVisible: Bool = false
    @State private var popUpImageURL: URL? = nil
    @State private var tabType: TabType = .home
    
    var body: some View {
        NavigationView {
            
            TabView {
                MinimoMainView(isPopUpVisible: $isPopUpVisible, popUpImageURL: $popUpImageURL, tabType: .home)
                    .environmentObject(minimoViewModel)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .onAppear {
                        tabType = .home
                    }
                ProfileView(tabType: .profile)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .onAppear {
                        tabType = .profile
                    }
                SearchView(tabType: .search)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .onAppear {
                        tabType = .search
                    }
            }
            .labelStyle(.iconOnly)
            
            .navigationTitle(tabType.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            isProfileVisible = true
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
        }
        .sheet(isPresented: $isProfileVisible) {
            EditProfileView(isProfileVisible: $isProfileVisible)
                .environmentObject(editProfileViewModel)
                .onDisappear {
                    minimoViewModel.fetchContents()
                }
        }
        .fullScreenCover(isPresented: $isPopUpVisible, content: {
            PopUpView(isPopUpVisible: $isPopUpVisible, popUpImageURL: $popUpImageURL)
        })
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TabMainView()
            .environmentObject(AuthModel(firebaseManager: FirebaseManager()))
            .environmentObject(
                MinimoViewModel(
                    userId: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                    firebaseManager: FirebaseManager()))
    }
}
