//
//  TimelineRow.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/28.
//

import SwiftUI

struct TimelineRow: View {
    @EnvironmentObject var timelineViewModel: TimelineViewModel
    @EnvironmentObject var timelineRowViewModel: TimelineRowViewModel
    
    var body: some View {
        HStack {
            VStack {
                ProfileImageView(userImage: $timelineRowViewModel.userImage)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(timelineRowViewModel.userName)
                        .font(.headline)
                    Spacer()
                    Button {
                        timelineRowViewModel.deleteContent()
                        timelineViewModel.fetchContents()
                    } label: {
                        Image(systemName: "trash.fill")
                    }
                    .foregroundColor(.black)
                }
                Text(timelineRowViewModel.content.content)
                    .lineLimit(nil)
                    .font(.body)
                Text(timelineRowViewModel.content.createdAt.formatted(date: .numeric, time: .shortened))
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing)
        }
        .padding()
        .background(Color(white: 0.9))
        .cornerRadius(10)
    }
}

struct TimelineRow_Previews: PreviewProvider {
    static var previews: some View {
        TimelineRow()
            .environmentObject(
                TimelineViewModel(user: UserDTO(
                    id: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                    name: "테스트"
                ),firebaseManager: FirebaseManager()))
            .environmentObject(TimelineRowViewModel(content: MinimoDTO(
                id: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                creator: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                createdAt: Date(),
                content: "얍"
            ), firebaseManager: FirebaseManager()))
    }
}
