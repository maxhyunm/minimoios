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
    private var isEmpty: Bool {
        return content == ""
    }
    
    var body: some View {
        HStack(spacing: 5) {
            TextEditor(text: $content)
                .padding()
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .border(Color(white: 0.8), width: 1)
            //                .cornerRadius(15)
            
            Button {
                minimoViewModel.createContents(body: content)
                self.content = ""
            } label: {
                Text("MO!")
                    .font(.headline)
                    .frame(width: 100, height: 100)
                    .background(Color(white: 0.8))
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .disabled(isEmpty)
        }
        .padding()
    }
}

struct WriteView_Previews: PreviewProvider {
    static var previews: some View {
        WriteView()
            .environmentObject(
                MinimoViewModel(userId: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                                firebaseManager: FirebaseManager()))
    }
}