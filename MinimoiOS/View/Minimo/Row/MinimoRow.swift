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
    @State var isAlertVisible: Bool = false
    @Binding var isPopUpVisible: Bool
    @Binding var popUpImageURL: URL?
    
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
                        isAlertVisible.toggle()
                    } label: {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .scaledToFit()
                    }
                    .buttonStyle(.plain)
                    .frame(width: 15, height: 15)
                    .foregroundColor(.black)
                    .alert(isPresented: $isAlertVisible) {
                        let okButton = Alert.Button.default(Text("네")) {
                            minimoRowViewModel.deleteContent()
                            minimoViewModel.fetchContents()
                        }
                        let cancelButton = Alert.Button.cancel(Text("취소"))
                        
                        return Alert(title: Text("삭제하기"),
                                     message: Text("삭제하시겠습니까?"),
                                     primaryButton: cancelButton,
                                     secondaryButton: okButton)
                    }
                }
                
                Text(minimoRowViewModel.content.content)
                    .lineLimit(nil)
                    .font(.body)
                Text(minimoRowViewModel.content.createdAt.formatted(date: .numeric, time: .shortened))
                    .font(.caption2)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(minimoRowViewModel.content.images, id: \.self) { url in

                            Button {
                                isPopUpVisible.toggle()
                                popUpImageURL = URL(string: url)
                            } label: {
                                AsyncImage(url: URL(string: url)) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                } placeholder: {
                                    Image(uiImage: UIImage())
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                }
                            }
                        }
                    }
                }
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
        MinimoRow(isPopUpVisible: .constant(true), popUpImageURL: .constant(nil))
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
