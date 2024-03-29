//
//  WriteView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import SwiftUI
import PhotosUI

struct WriteView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var tabType: Tab
    @ObservedObject var viewModel: HomeViewModel
    @State private var content = ""
    @State private var selectedItem = [PhotosPickerItem]()
    @State private var selectedImages = [UIImage]()
    @Binding var isWriting: Bool
    
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
                .foregroundColor(Colors.highlight(for: colorScheme))
                
                Spacer()
                
                Button {
                    viewModel.createContent(body: content, images: selectedImages)
                    content = ""
                    selectedItem = []
                    selectedImages = []
                    isWriting.toggle()
                } label: {
                    Text("MO!")
                        .font(.headline)
                }
                .padding()
                .background(isEmpty ? Color(white: 0.8) : Colors.highlight(for: colorScheme))
                .foregroundColor(Colors.background(for: colorScheme))
                .cornerRadius(15)
                .disabled(isEmpty)
            }
            
            TextEditor(text: $content)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(Color(white: 0.8), width: 1)
            
            ImageMultiSelectView(selectedItem: $selectedItem, selectedImages: $selectedImages)
        }
        .padding()
    }
}

struct WriteView_Previews: PreviewProvider {
    static var previews: some View {
        WriteView(viewModel: PreviewStatics.homeViewModel,
                  isWriting: .constant(true))
    }
}
