//
//  WriteButton.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/02.
//

import SwiftUI

struct WriteButton: View {
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var viewModel: MinimoModel
    @Binding var isWriting: Bool
    @Binding var fetchTrigger: Bool
    
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
            WriteView(isWriting: $isWriting,
                      fetchTrigger: $fetchTrigger)
            .environmentObject(userModel)
            .environmentObject(viewModel)
        }
    }
}

struct WriteButton_Previews: PreviewProvider {
    static var previews: some View {
        WriteButton(isWriting: .constant(false),
                    fetchTrigger: .constant(false))
        .environmentObject(PreviewStatics.writeViewModel)
    }
}
