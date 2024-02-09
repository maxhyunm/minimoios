//
//  ProfileImageView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/08.
//

import SwiftUI

struct ProfileImageView: View {
    @Environment(\.colorScheme) var colorScheme
    let image: String
    
    var body: some View {
        AsyncImage(url: URL(string: image)) { image in
            image.resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
                .padding()
        }
        .frame(width: 100, height: 100)
        .background(Colors.background(for: colorScheme))
        .foregroundColor(.pink)
        .scaledToFit()
        .clipShape(Circle())
        .overlay {
            Circle().stroke(Colors.background(for: colorScheme), lineWidth: 2)
        }
        .shadow(radius: 5)
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView(image: "test")
    }
}
