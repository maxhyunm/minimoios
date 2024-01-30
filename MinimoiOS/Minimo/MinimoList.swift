//
//  TimelineView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/27.
//

import SwiftUI

struct MinimoList: View {
    @EnvironmentObject var minimoViewModel: MinimoViewModel
    
    var body: some View {
        VStack {
            ForEach(minimoViewModel.contents, id: \.self) { content in
                let minimoRowViewModel = MinimoRowViewModel(
                    content: content,
                    firebaseManager: minimoViewModel.firebaseManager
                )
                MinimoRow()
                    .environmentObject(minimoViewModel)
                    .environmentObject(minimoRowViewModel)
            }
        }
        .padding()
        Spacer()
    }
}

struct TimelineList_Previews: PreviewProvider {
    static var previews: some View {
        MinimoList()
            .environmentObject(
                MinimoViewModel(userId: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                                firebaseManager: FirebaseManager()))
    }
}
