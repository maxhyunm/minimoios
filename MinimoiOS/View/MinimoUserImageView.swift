//
//  MinimoUserImageView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/30.
//

import SwiftUI

struct MinimoUserImageView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var userImage: String
    var image = UIImage()
    
    var body: some View {
        if userImage == "" {
            Image(uiImage: image)
                .resizable()
                .frame(width: 50, height: 50)
                .background(Colors.background(for: colorScheme))
                .foregroundColor(.pink)
                .scaledToFit()
                .clipShape(Circle())
                .frame(maxWidth: 50)
        } else {
            AsyncImage(url: URL(string: userImage)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
                    .padding()
            }
            .frame(width: 50, height: 50)
            .background(Colors.background(for: colorScheme))
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
