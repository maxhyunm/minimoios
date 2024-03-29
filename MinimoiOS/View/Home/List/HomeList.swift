//
//  MinimoList.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/27.
//

import SwiftUI

struct HomeList: View {
    @EnvironmentObject var userModel: UserModel
    @ObservedObject var viewModel: HomeViewModel
    @State private var fetchTrigger: Bool = false
    
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
                        userId: userModel.user.id.uuidString
                    )
                    HomeRow(viewModel: minimoRowViewModel,
                            fetchTrigger: $fetchTrigger)
                        .listRowSeparator(.hidden)
                }
                .padding(.horizontal)
            }
        }
//        .onPreferenceChange(ScrollOffsetKey.self) {
//            viewModel.newScrollOffset = $0
//        }
        .onChange(of: fetchTrigger) { _ in
            viewModel.fetchContents()
        }
        .refreshable {
            viewModel.fetchContents()
        }
        
    }
}

struct HomeList_Previews: PreviewProvider {
    static var previews: some View {
        HomeList(viewModel: PreviewStatics.homeViewModel)
    }
}
