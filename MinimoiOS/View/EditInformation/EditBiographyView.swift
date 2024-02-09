//
//  EditBiographyView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/09.
//

import SwiftUI

struct EditBiographyView: View {
    @State private var isBiographyValid: Bool = false
    @Binding var editable: Bool
    @Binding var biography: String
    @Binding var isBiographyChanged: Bool
    let originalBiography: String
    
    var body: some View {
        VStack {
            if editable {
                TextEditor(text: $biography)
                    .lineLimit(5)
                    .padding()
                    .frame(width: 250, height: 100)
                    .border(Color(white: 0.8), width: 1)
                    .onChange(of: biography) { newBio in
                        guard newBio != originalBiography,
                              newBio.count > 0,
                              newBio.count < 200 else {
                            isBiographyValid = false
                            return
                        }
                        isBiographyValid = true
                    }
                HStack {
                    Button {
                        self.editable.toggle()
                        self.isBiographyChanged = true
                    } label: {
                        Image(systemName: "checkmark.circle")
                    }
                    .disabled(!isBiographyValid)
                    .foregroundColor(!isBiographyValid ? .gray : .green)
                    
                    Button {
                        self.biography = self.originalBiography
                        self.isBiographyChanged = false
                        self.editable.toggle()
                    } label: {
                        Image(systemName: "x.circle")
                    }
                    .foregroundColor(.red)
                }
                
            } else {
                Text(biography)
                    .font(.body)
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

struct EditBiographyView_Previews: PreviewProvider {
    static var previews: some View {
        EditBiographyView(editable: .constant(false),
                          biography: .constant("test"),
                          isBiographyChanged: .constant(false),
                          originalBiography: "test")
    }
}
