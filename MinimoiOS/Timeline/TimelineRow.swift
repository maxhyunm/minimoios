//
//  TimelineRow.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/28.
//

import SwiftUI

struct TimelineRow: View {
    @EnvironmentObject var timelineViewModel: TimelineViewModel
    
    let content: ContentDTO
    
    var body: some View {
        HStack {
            VStack {
                Image(systemName: "teddybear.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .background(.white)
                    .foregroundColor(.pink)
                    .cornerRadius(45)
                    .frame(maxWidth: 50)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(content.name)
                        .font(.headline)
                    Spacer()
                    Button {
                        timelineViewModel.deleteContent(content.id)
                    } label: {
                        Image(systemName: "trash.fill")
                    }
                    .foregroundColor(.black)
                }
                Text(content.content)
                    .lineLimit(nil)
                    .font(.body)
                Text(content.createdAt.formatted(date: .numeric, time: .omitted))
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
        TimelineRow(content: ContentDTO(
            id: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
            creator: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
            name: "테스트",
            createdAt: Date(),
            content: "얍"
        ))
            .environmentObject(
                TimelineViewModel(user: UserDTO(
                    id: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                    name: "테스트",
                    email: "aaa@aaa.com",
                    createdAt: Date(),
                    oAuthType: .kakao
                ),firebaseManager: FirebaseManager()))
    }
}
