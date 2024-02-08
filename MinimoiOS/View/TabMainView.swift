//
//  TabMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import SwiftUI

struct TabMainView: View {
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var tabType: Tab
    @ObservedObject var homeModel: HomeViewModel
    @ObservedObject var profileModel: ProfileViewModel
    @ObservedObject var searchModel: SearchViewModel
    @State private var fetchTrigger: Bool = true
    
//    private var isScrollOnTop: Bool {
//        minimoViewModel.newScrollOffset >= minimoViewModel.originScrollOffset + 10.0
//    }
    
    var body: some View {
        VStack {
            ZStack {
                switch tabType.current {
                case .home:
                    HomeMainView(viewModel: homeModel,
                                 fetchTrigger: $fetchTrigger)
                case .profile:
                    ProfileMainView(viewModel: profileModel,
                                    ownerModel: userModel,
                                    fetchTrigger: $fetchTrigger)
                case .search:
                    SearchView(viewModel: searchModel,
                               fetchTrigger: $fetchTrigger)
                }
            }
            .onChange(of: fetchTrigger) { _ in
                switch tabType.current {
                case .home:
                    homeModel.fetchContents()
                case .profile:
                    profileModel.fetchContents()
                case .search:
                    break
                }
            }
            TabItemsView()
                .frame(height: 30)
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
//        TabMainView(minimoModel: PreviewStatics.minimoModel)
        TabMainView(homeModel: PreviewStatics.homeViewModel,
                    profileModel: PreviewStatics.profileViewModel,
                    searchModel: PreviewStatics.searchViewModel)
    }
}
