//
//  TimelineRow.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/28.
//

import SwiftUI

struct MinimoRow: View {
    @EnvironmentObject var minimoViewModel: MinimoViewModel
    @EnvironmentObject var minimoRowViewModel: MinimoRowViewModel
    
    var body: some View {
        HStack {
            VStack {
                MinimoUserImageView(userImage: $minimoRowViewModel.userImage)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(minimoRowViewModel.userName)
                        .font(.headline)
                    Spacer()
                    Button {
                        minimoRowViewModel.deleteContent()
                        minimoViewModel.fetchContents()
                    } label: {
                        Image(systemName: "trash.fill")
                    }
                    .foregroundColor(.black)
                }
                Text(minimoRowViewModel.content.content)
                    .lineLimit(nil)
                    .font(.body)
                Text(minimoRowViewModel.content.createdAt.formatted(date: .numeric, time: .shortened))
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

struct MinimoRow_Previews: PreviewProvider {
    static var previews: some View {
        MinimoRow()
            .environmentObject(
                MinimoViewModel(userId: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                                firebaseManager: FirebaseManager()))
            .environmentObject(MinimoRowViewModel(content: MinimoDTO(
                id: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                creator: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                createdAt: Date(),
                content: "얍"
            ), firebaseManager: FirebaseManager()))
    }
}
