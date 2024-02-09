//
//  InformationImage.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/07.
//

import SwiftUI
import PhotosUI

struct EditImageView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedItem = [PhotosPickerItem]()
    @Binding var selectedImage: UIImage
    @Binding var isImageChanged: Bool
    let originalImage: String
    
    var body: some View {
        VStack {
            if !isImageChanged {
                AsyncImage(url: URL(string: originalImage)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                        .padding()
                }
                .frame(width: 200, height: 200)
                .scaledToFit()
                .clipShape(Circle())
                .shadow(radius: 5)
            } else {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .scaledToFit()
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            
            PhotosPicker(
                selection: $selectedItem,
                maxSelectionCount: 1,
                matching: .images,
                photoLibrary: .shared()) {
                    Image(systemName: "camera.fill.badge.ellipsis")
                        .frame(width:50, height:50)
                        .scaledToFit()
                        .background(Colors.highlight(for: colorScheme))
                        .foregroundColor(Colors.background(for: colorScheme))
                        .clipShape(Circle())
                }
                .offset(x: 80, y: -50)
                .onChange(of: selectedItem) { item in
                    guard let selected = item.first else { return }
                    selected.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            guard let data,
                                  let image = UIImage(data: data) else { return }
                            selectedImage = image
                            isImageChanged = true
                        case .failure:
                            return
                        }
                    }
                }
        }
    }
}

struct InformationImage_Previews: PreviewProvider {
    static var previews: some View {
        EditImageView(selectedImage: .constant(UIImage()),
                      isImageChanged: .constant(false),
                      originalImage: "test")
    }
}
