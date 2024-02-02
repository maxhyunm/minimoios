//
//  WriteView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import SwiftUI
import PhotosUI

struct WriteView: View {
    @State private var content = ""
    @State private var selectedItem = [PhotosPickerItem]()
    @State private var selectedImages = [UIImage]()
    @Binding var isWriting: Bool
    @Binding var fetchTrigger: Bool
    let writeViewModel: WriteViewModel
    
    private var isEmpty: Bool {
        return content == "" && selectedItem.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Button {
                    content = ""
                    isWriting.toggle()
                } label: {
                    Text("Cancel")
                }
                .foregroundColor(.cyan)
                
                Spacer()
                
                Button {
                    writeViewModel.createContent(body: content, images: selectedImages)
                    content = ""
                    selectedItem = []
                    selectedImages = []
                    isWriting.toggle()
                    fetchTrigger.toggle()
                } label: {
                    Text("MO!")
                        .font(.headline)
                }
                .padding()
                .background(isEmpty ? Color(white: 0.8) : .cyan)
                .foregroundColor(.white)
                .cornerRadius(15)
                .disabled(isEmpty)
            }
            
            TextEditor(text: $content)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(Color(white: 0.8), width: 1)
            
            ScrollView(.horizontal) {
                HStack {
                    PhotosPicker(
                        selection: $selectedItem,
                        maxSelectionCount: 4,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Image(systemName: "camera.viewfinder")
                                .resizable()
                        }
                        .frame(width: 50, height: 50)
                        .padding()
                        .foregroundColor(.cyan)
                        .onChange(of: selectedItem) { item in
                            selectedImages = []
                            item.forEach { item in
                                item.loadTransferable(type: Data.self) { result in
                                    switch result {
                                    case .success(let data):
                                        guard let data,
                                              let image = UIImage(data: data) else { return }
                                        selectedImages.append(image)
                                    case .failure:
                                        return
                                    }
                                }
                            }
                        }

                        ForEach($selectedImages, id: \.self) { $image in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .scaledToFill()
                                    .border(.cyan)
                                
                                Button {
                                    guard let index = selectedImages.firstIndex(of: image) else { return }
                                    selectedImages.remove(at: index)
                                    selectedItem.remove(at: index)
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                }
                                .padding(2)
                                .frame(width: 15, height: 15)
                                .background(.cyan)
                                .foregroundColor(.white)
                            }
                        }
                }
                .padding()
            }
        }
        .padding()
    }
}

struct WriteView_Previews: PreviewProvider {
    static var previews: some View {
        WriteView(isWriting: .constant(true), fetchTrigger: .constant(false), writeViewModel: WriteViewModel(
            user: UserDTO(
                id: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                name: "테스트"
            ),
            firebaseManager: FirebaseManager()))
    }
}
