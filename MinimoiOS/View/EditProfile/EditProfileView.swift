//
//  ProfileView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/30.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var editProfileViewModel: EditProfileViewModel
    @State private var isImagePickerVisible: Bool = false
    @State private var editedName: String = ""
    @State private var editable: Bool = false
    @State private var selectedImage: UIImage = UIImage()
    @State private var isNameChanged: Bool = false
    @State private var isImageChanged: Bool = false
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
                    AsyncImage(url: URL(string: editProfileViewModel.user.image)) { image in
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
                    TextField("새로운 이름", text: $editedName)
                        .frame(width: 200)
                    Button {
                        self.editable.toggle()
                        self.isNameChanged = true
                    } label: {
                        Image(systemName: "checkmark.circle")
                    }
                    .disabled(editedName == "")
                    .foregroundColor(editedName == "" ? .gray : .green)
                    Button {
                        editedName = ""
                        self.editable.toggle()
                    } label: {
                        Image(systemName: "x.circle")
                    }
                    .foregroundColor(.red)
                } else {
                    Text(editedName == "" ? editProfileViewModel.user.name : editedName)
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
                    editProfileViewModel.updateName(self.editedName)
                }
                if isImageChanged {
                    editProfileViewModel.updateImage(selectedImage)
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

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(isProfileVisible: .constant(true), fetchTrigger: .constant(false))
            .environmentObject(EditProfileViewModel(user: UserDTO(
                id: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                name: "테스트"
            ), firebaseManager: FirebaseManager()))
    }
}
