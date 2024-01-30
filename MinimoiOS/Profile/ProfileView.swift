//
//  ProfileView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/30.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @Binding var isProfileVisible: Bool
    @State var isImagePickerVisible: Bool = false
    @State var editedName: String = ""
    @State var editable: Bool = false
    @State var selectedImage: UIImage = UIImage()
    @State var isNameChanged: Bool = false
    @State var isImageChanged: Bool = false
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
                    AsyncImage(url: URL(string: profileViewModel.user.image)) { image in
                        image.resizable()
                    } placeholder: {
                        Image(uiImage: UIImage())
                            .resizable()
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
                        .background(.blue)
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
                    Text(editedName == "" ? profileViewModel.user.name : editedName)
                        .font(.title3)
                    Button {
                        self.editable.toggle()
                    } label: {
                        Image(systemName: "pencil.line")
                    }
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
                    profileViewModel.updateName(self.editedName)
                }
                if isImageChanged {
                    profileViewModel.updateImage(selectedImage)
                }
                self.isProfileVisible = false
            } label: {
                Text("변경사항 저장")
            }
            .padding()
            .background(isChanged ? .blue : .gray)
            .foregroundColor(.white)
            .cornerRadius(15)
            .disabled(!isChanged)
            
            Spacer()
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isProfileVisible: .constant(true))
            .environmentObject(ProfileViewModel(user: UserDTO(
                id: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                name: "테스트"
            ), firebaseManager: FirebaseManager()))
    }
}
