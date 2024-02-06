//
//  ProfileView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/30.
//

import SwiftUI

struct EditInformationView: View {
    @EnvironmentObject var viewModel: EditInformationViewModel
    @State private var editable: Bool = false
    @State private var isImagePickerVisible: Bool = false
    @State private var selectedImage: UIImage = UIImage()
    @State private var isNameChanged: Bool = false
    @State private var isImageChanged: Bool = false
    @Binding var name: String
    @Binding var isProfileVisible: Bool
    @Binding var fetchTrigger: Bool

    var isChanged: Bool {
        return isNameChanged || isImageChanged
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    self.isProfileVisible = false
                } label: {
                    Text("Close")
                }
            }
            .padding()
            Spacer()
            
            VStack {
                if !isImageChanged {
                    AsyncImage(url: URL(string: viewModel.userModel.user.image)) { image in
                        image.resizable()
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
                        .frame(width: 200, height: 200)
                        .scaledToFit()
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                
                Button {
                    self.isImagePickerVisible = true
                } label: {
                    Image(systemName: "camera.fill.badge.ellipsis")
                        .frame(width:50, height:50)
                        .scaledToFit()
                        .background(.cyan)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .offset(x: 80, y: -50)
            }
            .sheet(isPresented: $isImagePickerVisible) {
                ImagePicker(sourceType: .photoLibrary,
                            selectedImage: $selectedImage,
                            isImagePickerVisible: $isImagePickerVisible,
                            isImageChanged: $isImageChanged)
                .onDisappear {
                    self.isImagePickerVisible = false
                }
            }
            
            HStack {
                if editable {
                    TextField("새로운 이름", text: $name)
                        .frame(width: 200)
                        .onChange(of: name) { _ in
                            if !isNameChanged {
                                isNameChanged.toggle()
                            }
                        }
                    
                    Button {
                        self.editable.toggle()
                        self.isNameChanged = true
                    } label: {
                        Image(systemName: "checkmark.circle")
                    }
                    .disabled(!isNameChanged)
                    .foregroundColor(!isNameChanged ? .gray : .green)
                    
                    Button {
                        self.editable.toggle()
                    } label: {
                        Image(systemName: "x.circle")
                    }
                    .foregroundColor(.red)
                    
                } else {
                    Text(name)
                        .font(.title3)
                    Button {
                        self.editable.toggle()
                    } label: {
                        Image(systemName: "pencil.line")
                    }
                    .foregroundColor(.cyan)
                }
            }
            .padding()
            
            if let latestOAuthType = UserDefaults.standard.object(forKey: "latestOAuthType") as? String {
                Text("Logged in with \(latestOAuthType)")
                    .font(.caption)
            }
            
            Spacer()
            
            Button {
                if isNameChanged {
                    viewModel.updateName(self.name)
                }
                if isImageChanged {
                    viewModel.updateImage(selectedImage)
                }
                self.isProfileVisible = false
                self.fetchTrigger.toggle()
            } label: {
                Text("변경사항 저장")
            }
            .padding()
            .background(isChanged ? .cyan : .gray)
            .foregroundColor(.white)
            .cornerRadius(15)
            .disabled(!isChanged)
            
            Spacer()
        }
    }
}

struct EditInformationView_Previews: PreviewProvider {
    static var previews: some View {
        EditInformationView(name: .constant("test"),
                            isProfileVisible: .constant(true),
                            fetchTrigger: .constant(false))
    }
}
