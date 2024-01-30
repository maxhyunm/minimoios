//
//  TimelineProfileImageView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/30.
//

import SwiftUI

struct MinimoUserImageView: View {
    @Binding var userImage: String
    var image = UIImage()
    
    var body: some View {
        if userImage == "" {
            Image(systemName: "teddybear.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .background(.white)
                .foregroundColor(.pink)
                .scaledToFit()
                .clipShape(Circle())
                .frame(maxWidth: 50)
        } else {
            AsyncImage(url: URL(string: userImage)) { image in
                image.resizable()
            } placeholder: {
                Image(uiImage: UIImage())
                    .resizable()
            }
            .frame(width: 50, height: 50)
            .background(.white)
            .foregroundColor(.pink)
            .scaledToFit()
            .clipShape(Circle())
            .frame(maxWidth: 50)
            
        }
    }
}

struct MinimoUserImageView_Previews: PreviewProvider {
    static var previews: some View {
        MinimoUserImageView(userImage: .constant(""))
    }
}