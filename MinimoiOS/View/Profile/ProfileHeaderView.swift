//
//  ProfileHeaderView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject var userModel: UserModel
    @Binding var ownerModel: UserModel
    private let backgroundColor: Color = .cyan
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.cyan, Color.cyan]),
                    startPoint: .top,
                    endPoint: .bottom)
                .frame(height: 100)
                Color.white
            }
            
            HStack(alignment: .top, spacing: 15) {
                AsyncImage(url: URL(string: ownerModel.user.image)) { image in
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
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(ownerModel.user.name)
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                    HStack(alignment: .center, spacing: 10) {
                        Text("Following")
                        Text("\(ownerModel.followings.count)")
                        Text("|")
                        Text("Follower")
                        Text("\(ownerModel.followers.count)")
                        Spacer()
                    }
                    .font(.caption2)
                    .padding(.bottom, 10)
                    Text("Bio")
                    Spacer()
                }
            }
            .padding(.horizontal, 10)
            .offset(x: 0, y: 50)
        }
        .frame(height: 160)
        .offset(x: 0, y: -30)
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(ownerModel: .constant(PreviewStatics.userModel))
            .environmentObject(PreviewStatics.userModel)
    }
}
