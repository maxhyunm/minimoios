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
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.cyan, Color.cyan]),
                    startPoint: .top,
                    endPoint: .bottom)
                .frame(height: 100)
                
                HStack(alignment: .bottom, spacing: 10) {
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
                    .overlay {
                        Circle().stroke(.white, lineWidth: 2)
                    }
                    .shadow(radius: 5)
                    .padding(.leading, 5)
                    
                    Text(user.name)
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                        .offset(x: 0, y: -15)
                }
                .padding(10)
                .offset(x: 0, y: 50)
            }
            .frame(height: 160)
            .offset(x: 0, y: -30)
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(user: UserDTO(id: UUID(), name: "테스트"), tabType: .home)
    }
}
