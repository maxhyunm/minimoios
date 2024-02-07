//
//  ProfileHeaderView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var ownerModel: UserModel
    @State private var isEditInformationVisible: Bool = false
    @Binding var fetchTrigger: Bool
    
    var isUsersProfile: Bool {
        return userModel.user.id == ownerModel.user.id
    }
    var isFollowing: Bool {
        return userModel.followings.contains(ownerModel.user.id)
    }
    
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
            VStack {
                HStack {
                    Spacer()
                    if isUsersProfile {
                        Button {
                            isEditInformationVisible = true
                        } label: {
                            Text("Edit")
                                .font(.subheadline)
                                .padding(5)
                                .background(.white)
                                .foregroundColor(.cyan)
                                .cornerRadius(5)
                        }
                    } else {
                        Button {
                            if isFollowing {
                                userModel.unfollow(for: ownerModel.user.id)
                            } else {
                                userModel.follow(for: ownerModel.user.id)
                            }
                        } label: {
                            Text(isFollowing ? "Unfollow" : "Follow")
                                .font(.subheadline)
                                .padding(5)
                                .background(.black)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                }
                .frame(height: 20)
                .padding(.trailing, 15)
                .padding(.top, 20)
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
//                .offset(x: 0, y: 30)
            }
        }
        .frame(height: 140)
        .offset(x: 0, y: -10)
        .sheet(isPresented: $isEditInformationVisible) {
            EditInformationView(name: userModel.user.name,
                                isVisible: $isEditInformationVisible,
                                fetchTrigger: $fetchTrigger)
            .environmentObject(userModel)
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(fetchTrigger: .constant(false))
            .environmentObject(PreviewStatics.userModel)
            .environmentObject((PreviewStatics.userModel))
    }
}
