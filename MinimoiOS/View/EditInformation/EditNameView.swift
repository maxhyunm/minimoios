//
//  EditNameView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/07.
//

import SwiftUI

struct EditNameView: View {
    @State private var isNameValid: Bool = false
    @Binding var editable: Bool
    @Binding var name: String
    @Binding var isNameChanged: Bool
    let originalName: String
    
    var body: some View {
        HStack {
            if editable {
                TextField("Name", text: $name)
                    .frame(width: 200)
                    .onChange(of: name) { newName in
                        guard newName != originalName,
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
                    self.name = self.originalName
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
        .padding(5)
    }
}

struct EditNameView_Previews: PreviewProvider {
    static var previews: some View {
        EditNameView(editable: .constant(false),
                     name: .constant("test"),
                     isNameChanged: .constant(false),
                     originalName: "test")
    }
}
