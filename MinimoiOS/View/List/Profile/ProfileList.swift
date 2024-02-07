//
//  ProfileList.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/02.
//

import SwiftUI

struct ProfileList: View {
    @EnvironmentObject var userModel: UserModel
    @ObservedObject var viewModel: MinimoModel
    @ObservedObject var ownerModel: UserModel
    @Binding var fetchTrigger: Bool
    
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
                let headerView = ProfileHeaderView(ownerModel: ownerModel,
                                                   fetchTrigger: $fetchTrigger)
                Section(header: headerView) {
                    ForEach($viewModel.contents) { $content in
                        let minimoRowViewModel = MinimoRowViewModel(
                            content: content,
                            firebaseManager: viewModel.firebaseManager,
                            userId: userModel.user.id.uuidString
                        )
                        ProfileRow(viewModel: minimoRowViewModel,
                                   fetchTrigger: $fetchTrigger)
                            .listRowSeparator(.hidden)
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
        ProfileList(viewModel: PreviewStatics.minimoModel,
                    ownerModel: PreviewStatics.userModel,
                    fetchTrigger: .constant(false))
    }
}
