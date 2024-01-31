//
//  MinimoList.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/27.
//

import SwiftUI

struct MinimoList: View {
    @EnvironmentObject var minimoViewModel: MinimoViewModel
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
                Section(header: ProfileHeaderView(user: minimoViewModel.user, tabType: tabType)) {
                    ForEach(minimoViewModel.contents) { content in
                        let minimoRowViewModel = MinimoRowViewModel(
                            content: content,
                            firebaseManager: minimoViewModel.firebaseManager
                        )
                        MinimoRow()
                            .listRowSeparator(.hidden)
                            .environmentObject(minimoViewModel)
                            .environmentObject(minimoRowViewModel)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onPreferenceChange(ScrollOffsetKey.self) {
            minimoViewModel.newScrollOffset = $0
        }
        .refreshable {
            minimoViewModel.fetchContents()
        }
    }
}

struct TimelineList_Previews: PreviewProvider {
    static var previews: some View {
        MinimoList(tabType: .home)
        
            .environmentObject(
                MinimoViewModel(
                    user: UserDTO(
                        id: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                        name: "테스트"),
                    firebaseManager: FirebaseManager()))
    }
}
