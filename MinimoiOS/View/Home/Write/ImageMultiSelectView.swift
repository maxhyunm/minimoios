//
//  ImageMultiSelectView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/07.
//

import SwiftUI
import PhotosUI

struct ImageMultiSelectView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedItem: [PhotosPickerItem]
    @Binding var selectedImages: [UIImage]
    
    var body: some View {
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
                    .foregroundColor(Colors.highlight(for: colorScheme))
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
                            .border(Colors.highlight(for: colorScheme))
                        
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
                        .background(Colors.highlight(for: colorScheme))
                        .foregroundColor(Colors.background(for: colorScheme))
                    }
                }
            }
            .padding()
        }
    }
}

struct ImageMultiSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ImageMultiSelectView(selectedItem: .constant([]), selectedImages: .constant([]))
    }
}
