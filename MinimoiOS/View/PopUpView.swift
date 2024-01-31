//
//  PopUpView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct PopUpView: View {
    @Binding var isPopUpVisible: Bool
    @Binding var popUpImageURL: URL?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let popUpImageURL {
                AsyncImage(url: popUpImageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: UIScreen.main.bounds.width - 50)
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .padding()
                }
                .shadow(radius: 20)
                
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(3)
                    .background(.gray)
                    .foregroundColor(.white)
                    .offset(x: 0, y: -26)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .ignoresSafeArea(.all)
        .background(Color(white: 0.5))
        .onTapGesture {
            isPopUpVisible.toggle()
        }
    }
}

struct PopUpView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpView(isPopUpVisible: .constant(true), popUpImageURL: .constant(nil))
    }
}
