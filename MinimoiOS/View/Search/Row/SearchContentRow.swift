//
//  SearchContentRow.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/08.
//

import SwiftUI

struct SearchContentRow: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userModel: UserModel
    @ObservedObject var viewModel: MinimoRowViewModel
    @State private var removeAlertTrigger: Bool = false
    @State private var isPopUpVisible: Bool = false
    @State private var popUpImageURL: URL? = nil

    
    var body: some View {
        HStack {
            VStack {
                MinimoUserImageView(userImage: $viewModel.creatorImage)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(viewModel.creatorName)
                            .font(.headline)
                            .tint(Colors.basic(for: colorScheme))
                    
                    Spacer()
                }
                
                Text(viewModel.content.content)
                    .lineLimit(nil)
                    .font(.body)
                Text(viewModel.content.createdAt.formatted(date: .numeric, time: .shortened))
                    .font(.caption2)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.content.images, id: \.self) { url in
                            
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
                                    ProgressView()
                                        .padding()
                                        .frame(width: 100, height: 100)
                                }
                            }
                        }
                    }
                }
                HStack(alignment: .center) {
                    Spacer()
                    Button {
                        viewModel.toggleClap()
                    } label: {
                        Image(systemName: "hands.clap.fill")
                        Text("\(viewModel.clapCount)")
                            .font(.callout)
                    }
                    .tint(viewModel.didUserClap ? Colors.highlight(for: colorScheme) : Colors.basic(for: colorScheme))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing)
        }
        .padding()
        .background(Colors.minimoRow(for: colorScheme))
        .cornerRadius(10)
        .fullScreenCover(isPresented: $isPopUpVisible, content: {
            PopUpView(isPopUpVisible: $isPopUpVisible, popUpImageURL: $popUpImageURL)
        })
    }
}

struct SearchContentRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchContentRow(viewModel: PreviewStatics.minimoRowModel)
    }
}
