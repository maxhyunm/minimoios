//
//  TabMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import SwiftUI

struct TabMainView: View {
    @EnvironmentObject var userModel: UserModel
    @ObservedObject var minimoModel: MinimoModel
    @State private var fetchTrigger: Bool = true
    @State private var tabType: TabType = .home
    @Binding var logOutTrigger: Bool
    
//    private var isScrollOnTop: Bool {
//        minimoViewModel.newScrollOffset >= minimoViewModel.originScrollOffset + 10.0
//    }
    
    var body: some View {
        VStack {
            ZStack {
                switch tabType {
                case .home:
                    HomeMainView(viewModel: minimoModel,
                                 fetchTrigger: $fetchTrigger,
                                 logOutTrigger: $logOutTrigger)
                case .profile:
                    ProfileMainView(viewModel: minimoModel,
                                    ownerModel: userModel,
                                    fetchTrigger: $fetchTrigger)
                case .search:
                    SearchView(fetchTrigger: $fetchTrigger,
                               logOutTrigger: $logOutTrigger)
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
        TabMainView(minimoModel: PreviewStatics.minimoModel,
                    logOutTrigger: .constant(false))
    }
}
