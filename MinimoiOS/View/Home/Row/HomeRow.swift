//
//  HomeRow.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/07.
//

import SwiftUI

struct HomeRow: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var tabType: Tab
    @ObservedObject var viewModel: MinimoRowViewModel
    @State private var removeAlertTrigger: Bool = false
    @State private var isPopUpVisible: Bool = false
    @State private var popUpImageURL: URL? = nil
    @Binding var fetchTrigger: Bool

    
    var body: some View {
        HStack {
            VStack {
                MinimoUserImageView(userImage: $viewModel.creatorImage)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    if let ownerModel = viewModel.creatorModel {
                        let profileViewModel = ProfileViewModel(
                            ownerId: ownerModel.user.id,
                            firebaseManager: viewModel.firebaseManager
                        )
                        let owner = ownerModel.user.id == userModel.user.id ? userModel : ownerModel
                        NavigationLink {
                            ProfileMainView(viewModel: profileViewModel,
                                            ownerModel: owner)
                            .onAppear {
                                tabType.isNavigating = true
                            }
                        } label: {
                            Text(viewModel.creatorName)
                                .font(.headline)
                                .tint(Colors.basic(for: colorScheme))
                        }
                    } else {
                        Text(viewModel.creatorName)
                            .font(.headline)
                            .tint(Colors.basic(for: colorScheme))
                    }
                    
                    Spacer()
                    
                    if viewModel.userId == viewModel.creatorId {
                        Button {
                            removeAlertTrigger.toggle()
                        } label: {
                            Image(systemName: "trash.fill")
                                .resizable()
                                .scaledToFit()
                        }
                        .buttonStyle(.plain)
                        .frame(width: 15, height: 15)
                        .foregroundColor(Colors.basic(for: colorScheme))
                        .alert(isPresented: $removeAlertTrigger) {
                            let okButton = Alert.Button.default(Text("네")) {
                                viewModel.deleteContent()
                                fetchTrigger.toggle()
                            }
                            let cancelButton = Alert.Button.cancel(Text("취소"))
                            
                            return Alert(title: Text("삭제하기"),
                                         message: Text("삭제하시겠습니까?"),
                                         primaryButton: cancelButton,
                                         secondaryButton: okButton)
                        }
                        .disabled(viewModel.userId != viewModel.creatorId)
                    }
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
        }
        .padding()
        .background(Colors.minimoRow(for: colorScheme))
        .cornerRadius(10)
        .fullScreenCover(isPresented: $isPopUpVisible, content: {
            PopUpView(isPopUpVisible: $isPopUpVisible, popUpImageURL: $popUpImageURL)
        })
    }
}

struct HomeRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeRow(viewModel: PreviewStatics.minimoRowModel,
                fetchTrigger: .constant(false))
    }
}
