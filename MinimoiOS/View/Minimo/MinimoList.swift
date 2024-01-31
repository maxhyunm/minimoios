//
//  TimelineView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/27.
//

import SwiftUI

struct MinimoList: View {
    @EnvironmentObject var minimoViewModel: MinimoViewModel
    @Binding var isPopUpVisible: Bool
    @Binding var popUpImageURL: URL?
    
    var body: some View {
        ZStack {
            List(minimoViewModel.contents) { content in
                let minimoRowViewModel = MinimoRowViewModel(
                    content: content,
                    firebaseManager: minimoViewModel.firebaseManager
                )
                MinimoRow(isPopUpVisible: $isPopUpVisible, popUpImageURL: $popUpImageURL)
                    .listRowSeparator(.hidden)
                    .environmentObject(minimoViewModel)
                    .environmentObject(minimoRowViewModel)
            }
            .listStyle(.plain)
            .refreshable {
                minimoViewModel.fetchContents()
            }
        }
    }
}

struct TimelineList_Previews: PreviewProvider {
    static var previews: some View {
        MinimoList(isPopUpVisible: .constant(true), popUpImageURL: .constant(nil))
            .environmentObject(
                MinimoViewModel(userId: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                                firebaseManager: FirebaseManager()))
    }
}
