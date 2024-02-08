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
    @State private var selectedImage: UIImage = UIImage()
    @State private var isNameChanged: Bool = false
    @State private var isImageChanged: Bool = false
    @State private var name: String
    @Binding var isVisible: Bool
    
    init(name: String, isVisible: Binding<Bool>) {
        self._name = State(initialValue: name)
        self._isVisible = isVisible
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
            
            EditImageView(selectedImage: $selectedImage,
                          isImageChanged: $isImageChanged,
                          originalImage: userModel.user.image)
            
            EditNameView(editable: $editable,
                         name: $name,
                         isNameChanged: $isNameChanged,
                         originalName: userModel.user.name)
            
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
            } label: {
                Text("변경사항 저장")
            }
            .padding()
            .background(isChanged && !editable ? .cyan : .gray)
            .foregroundColor(.white)
            .cornerRadius(15)
            .disabled(!isChanged || editable)
            
            Spacer()
        }
    }
}

struct EditInformationView_Previews: PreviewProvider {
    static var previews: some View {
        EditInformationView(name: "test",
                            isVisible: .constant(true))
    }
}
