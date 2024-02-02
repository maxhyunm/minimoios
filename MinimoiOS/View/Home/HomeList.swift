//
//  MinimoList.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/27.
//

import SwiftUI

struct HomeList: View {
    @EnvironmentObject var viewModel: HomeViewModel
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
                ForEach($viewModel.contents) { $content in
                    let minimoRowViewModel = MinimoRowViewModel(
                        content: content,
                        firebaseManager: viewModel.firebaseManager,
                        userId: viewModel.user.id.uuidString
                    )
                    MinimoRow(fetchTrigger: $fetchTrigger)
                        .listRowSeparator(.hidden)
                        .environmentObject(minimoRowViewModel)
                }
                .padding(.horizontal)
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

struct HomeList_Previews: PreviewProvider {
    static var previews: some View {
        HomeList(fetchTrigger: .constant(false), tabType: .home)
            .environmentObject(PreviewStatics.homeViewModel)
    }
}
