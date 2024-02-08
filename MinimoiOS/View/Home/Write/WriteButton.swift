//
//  WriteButton.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/02.
//

import SwiftUI

struct WriteButton: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var isWriting: Bool
    
    var body: some View {
        Button {
            isWriting.toggle()
        } label: {
            Image(systemName: "pencil")
                .resizable()
        }
        .frame(width: 30, height: 30)
        .padding()
        .background(.cyan)
        .foregroundColor(.white)
        .clipShape(Circle())
        .offset(x: -30, y: -20)
        .sheet(isPresented: $isWriting) {
            WriteView(viewModel: viewModel,
                      isWriting: $isWriting)
        }
    }
}

struct WriteButton_Previews: PreviewProvider {
    static var previews: some View {
        WriteButton(viewModel: PreviewStatics.homeViewModel,
                    isWriting: .constant(false))
    }
}
