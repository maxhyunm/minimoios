//
//  ProfileView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/30.
//

import SwiftUI

struct EditInformationView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userModel: UserModel
    @State private var isNameEditable: Bool = false
    @State private var isBiographyEditable: Bool = false
    @State private var selectedImage: UIImage = UIImage()
    @State private var isNameChanged: Bool = false
    @State private var isImageChanged: Bool = false
    @State private var isBiographyChanged: Bool = false
    @State private var name: String
    @State private var biography: String
    @Binding var isVisible: Bool
    
    init(name: String, biography: String, isVisible: Binding<Bool>) {
        self._name = State(initialValue: name)
        self._biography = State(initialValue: biography)
        self._isVisible = isVisible
    }
    
    var isChanged: Bool {
        return isNameChanged || isImageChanged || isBiographyChanged
    }
    
    var isEditing: Bool {
        return isNameEditable || isBiographyEditable
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
            
            EditNameView(editable: $isNameEditable,
                         name: $name,
                         isNameChanged: $isNameChanged,
                         originalName: userModel.user.name)
            
            EditBiographyView(editable: $isBiographyEditable,
                              biography: $biography,
                              isBiographyChanged: $isBiographyChanged,
                              originalBiography: userModel.user.biography)
            
            if let latestOAuthType = UserDefaults.standard.object(forKey: "latestOAuthType") as? String {
                Text("Logged in with \(latestOAuthType)")
                    .font(.caption)
                    .padding()
            }
            
            Spacer()
            
            Button {
                if isNameChanged {
                    userModel.updateName(name)
                }
                if isImageChanged {
                    userModel.updateImage(selectedImage)
                }
                if isBiographyChanged {
                    userModel.updateBiography(biography)
                }
                isVisible = false
            } label: {
                Text("변경사항 저장")
            }
            .padding()
            .background(isChanged && !isEditing ? Colors.highlight(for: colorScheme) : Colors.borders(for: colorScheme))
            .foregroundColor(Colors.background(for: colorScheme))
            .cornerRadius(15)
            .disabled(!isChanged || isEditing)
            
            Spacer()
        }
    }
}

struct EditInformationView_Previews: PreviewProvider {
    static var previews: some View {
        EditInformationView(name: "test",
                            biography: "test",
                            isVisible: .constant(true))
    }
}
