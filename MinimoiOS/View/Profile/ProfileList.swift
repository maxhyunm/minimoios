//
//  ProfileList.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/02.
//

import SwiftUI

struct ProfileList: View {
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var viewModel: ProfileViewModel
    @Binding var fetchTrigger: Bool
    var tabType: TabType
    
//    private var scrollOffsetObserver: some View {
//        GeometryReader { geo in
//            let offsetY = geo.frame(in: .global).origin.y
//            Color.clear
//                .preference(key: ScrollOffsetKey.self, value: offsetY)
//                .onAppear {
//                    self.minimoViewModel.originScrollOffset = offsetY
//                }
//        }
//        .frame(height: 0)
//    }
    
    var body: some View {
        ScrollView {
//            scrollOffsetObserver
            LazyVStack  {
                let headerView = ProfileHeaderView(tabType: tabType)
                    .environmentObject(userModel)
                Section(header: headerView) {
                    ForEach($viewModel.contents) { $content in
                        let minimoRowViewModel = MinimoRowViewModel(
                            content: content,
                            firebaseManager: viewModel.firebaseManager,
                            userId: userModel.user.id.uuidString
                        )
                        MinimoRow(fetchTrigger: $fetchTrigger)
                            .listRowSeparator(.hidden)
                            .environmentObject(minimoRowViewModel)
                    }
                    .padding(.horizontal)
                }
            }
        }
//        .onPreferenceChange(ScrollOffsetKey.self) {
//            viewModel.newScrollOffset = $0
//        }
        .refreshable {
            fetchTrigger.toggle()
        }
    }
}

struct ProfileList_Previews: PreviewProvider {
    static var previews: some View {
        ProfileList(fetchTrigger: .constant(false), tabType: .home)
            .environmentObject(PreviewStatics.userModel)
            .environmentObject(PreviewStatics.profileViewModel)
    }
}
