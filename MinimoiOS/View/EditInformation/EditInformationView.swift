//
//  ProfileView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/30.
//

import SwiftUI

struct EditInformationView: View {
    @EnvironmentObject var userModel: UserModel
    @State private var editable: Bool = false
    @State private var isImagePickerVisible: Bool = false
    @State private var selectedImage: UIImage = UIImage()
    @State private var isNameValid: Bool = false
    @State private var isNameChanged: Bool = false
    @State private var isImageChanged: Bool = false
    @State private var name: String
    @Binding var isVisible: Bool
    @Binding var fetchTrigger: Bool
    
    init(name: String, isVisible: Binding<Bool>, fetchTrigger: Binding<Bool>) {
        self._name = State(initialValue: name)
        self._isVisible = isVisible
        self._fetchTrigger = fetchTrigger
    }
    
    var isChanged: Bool {
        return isNameChanged || isImageChanged
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    self.isVisible = false
                } label: {
                    Text("Close")
                }
            }
            .padding()
            Spacer()
            
            VStack {
                if !isImageChanged {
                    AsyncImage(url: URL(string: userModel.user.image)) { image in
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
                        .onChange(of: name) { newName in
                            guard newName != userModel.user.name,
                                  newName.count > 0,
                                  newName.count < 20 else {
                                isNameValid = false
                                return
                            }
                            isNameValid = true
                        }
                    
                    Button {
                        self.editable.toggle()
                        self.isNameChanged = true
                    } label: {
                        Image(systemName: "checkmark.circle")
                    }
                    .disabled(!isNameValid)
                    .foregroundColor(!isNameValid ? .gray : .green)
                    
                    Button {
                        self.name = self.userModel.user.name
                        self.isNameChanged = false
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
                    userModel.updateName(self.name)
                }
                if isImageChanged {
                    userModel.updateImage(selectedImage)
                }
                self.isVisible = false
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
        EditInformationView(name: "test",
                            isVisible: .constant(true),
                            fetchTrigger: .constant(false))
    }
}
