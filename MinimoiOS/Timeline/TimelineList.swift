//
//  TimelineView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/27.
//

import SwiftUI

struct TimelineList: View {
    @EnvironmentObject var authModel: AuthModel
    @EnvironmentObject var timelineViewModel: TimelineViewModel
    
    var body: some View {
            VStack {
                ForEach(timelineViewModel.contents, id: \.self) { content in
                    TimelineRow(content: content)
                        .environmentObject(timelineViewModel)
                }
            }
        .padding()
        Spacer()
    }
}

struct TimelineList_Previews: PreviewProvider {
    static var previews: some View {
        TimelineList()
            .environmentObject(AuthModel(firebaseManager: FirebaseManager()))
            .environmentObject(
                TimelineViewModel(user: UserDTO(
                    id: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                    name: "테스트",
                    createdAt: Date()
                ),firebaseManager: FirebaseManager()))
    }
}
