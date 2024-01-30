//
//  WriteView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import SwiftUI

struct WriteView: View {
    @EnvironmentObject var minimoViewModel: MinimoViewModel
    @State private var content: String = ""
    @Binding var isWriting: Bool
    
    private var isEmpty: Bool {
        return content == ""
    }
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Button {
                    content = ""
                    isWriting.toggle()
                } label: {
                    Text("Cancel")
                }
                .foregroundColor(.cyan)
                
                Spacer()
                
                Button {
                    minimoViewModel.createContents(body: content)
                    content = ""
                    isWriting.toggle()
                } label: {
                    Text("MO!")
                        .font(.headline)
                }
                .padding()
                .background(isEmpty ? Color(white: 0.8) : .cyan)
                .foregroundColor(.white)
                .cornerRadius(15)
                .disabled(isEmpty)
            }
            
            TextEditor(text: $content)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(Color(white: 0.8), width: 1)
        }
        .padding()
    }
}

struct WriteView_Previews: PreviewProvider {
    static var previews: some View {
        WriteView(isWriting: .constant(true))
            .environmentObject(
                MinimoViewModel(userId: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                                firebaseManager: FirebaseManager()))
    }
}
