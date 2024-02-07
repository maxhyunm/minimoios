//
//  TabMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import SwiftUI

struct TabMainView: View {
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var minimoModel: MinimoModel
//    @EnvironmentObject var homeViewModel: MinimoModel
//    @EnvironmentObject var profileViewModel: MinimoModel
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
            ZStack {
                switch tabType {
                case .home:
                    HomeMainView(fetchTrigger: $fetchTrigger,
                                 logOutTrigger: $logOutTrigger)
                    .environmentObject(userModel)
                    .environmentObject(minimoModel)
                case .profile:
                    ProfileMainView(fetchTrigger: $fetchTrigger)
                    .environmentObject(userModel)
                    .environmentObject(minimoModel)
                case .search:
                    SearchView(fetchTrigger: $fetchTrigger,
                               logOutTrigger: $logOutTrigger)
                    .environmentObject(userModel)
                }
            }
            .onChange(of: fetchTrigger) { _ in
                switch tabType {
                case .home:
                    minimoModel.fetchFollowingContents(followings: userModel.followings)
                case .profile:
                    minimoModel.fetchProfileContents()
                case .search:
                    break
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
