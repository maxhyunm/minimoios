//
//  ImageMultiSelectView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/07.
//

import SwiftUI
import PhotosUI

struct ImageMultiSelectView: View {
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
}

struct ImageMultiSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ImageMultiSelectView(selectedItem: .constant([]), selectedImages: .constant([]))
    }
}
