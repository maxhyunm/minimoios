//
//  TimelineView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var authModel: AuthModel
    @EnvironmentObject var timelineViewModel: TimelineViewModel
    
    var body: some View {
        VStack(spacing: 5) {
            TopMenuView()
                .environmentObject(authModel)
            ScrollView {
                WriteView()
                TimelineList()
                    .onAppear {
                        timelineViewModel.fetchContents()
                    }
                    .environmentObject(authModel)
                    .environmentObject(timelineViewModel)
            }
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
            .environmentObject(AuthModel(firebaseManager: FirebaseManager()))
            .environmentObject(
                TimelineViewModel(user: UserDTO(
                    id: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                    name: "테스트",
                    createdAt: Date()
                ),firebaseManager: FirebaseManager()))
    }
}
