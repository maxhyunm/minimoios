//
//  ProfileHeaderView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct ProfileHeaderView: View {
    private let backgroundColor: Color = .cyan
    var user: UserDTO
    var tabType: TabType
    
    var body: some View {
        if tabType == .profile {
            ZStack(alignment: .leading) {
                backgroundColor
                
                HStack(alignment: .center, spacing: 10) {
                    AsyncImage(url: URL(string: user.image)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                            .padding()
                    }
                    .frame(width: 100, height: 100)
                    .background(.white)
                    .foregroundColor(.pink)
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(maxWidth: 100)
                    
                    Text(user.name)
                        .foregroundColor(.white)
                        .font(.title3)
                }
                .padding(10)
            }
            .frame(height: 150)
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(user: UserDTO(id: UUID(), name: "테스트"), tabType: .home)
    }
}
