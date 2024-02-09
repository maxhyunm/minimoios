//
//  ProfileHeaderView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject var userModel: UserModel
    @ObservedObject var ownerModel: UserModel
    @ObservedObject var viewModel: ProfileViewModel
    @State private var isEditInformationVisible: Bool = false
    
    var isUsersProfile: Bool {
        return userModel.user.id == ownerModel.user.id
    }
    var isFollowing: Bool {
        return userModel.followings.contains(ownerModel.user.id)
    }
    
    private let backgroundColor: Color = .cyan
    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.cyan, Color.cyan]),
                startPoint: .top,
                endPoint: .bottom)
            .background(ignoresSafeAreaEdges: .top)
            .frame(height: 100)
            
            VStack(alignment: .leading, spacing: 5) {
                ProfileSearchView(viewModel: viewModel)
                
                HStack(alignment: .bottom) {
                    ProfileImageView(image: ownerModel.user.image)
                    
                    Spacer()
                    
                    if isUsersProfile {
                        Button {
                            isEditInformationVisible = true
                        } label: {
                            Text("Edit")
                                .font(.subheadline)
                                .padding(5)
                                .background(.cyan)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                                .padding(.bottom, 10)
                        }
                    } else {
                        Button {
                            if isFollowing {
                                userModel.unfollow(for: ownerModel.user.id)
                                Task {
                                    await ownerModel.fetchFollowings()
                                    await ownerModel.fetchFollowers()
                                }
                            } else {
                                userModel.follow(for: ownerModel.user.id)
                                Task {
                                    await ownerModel.fetchFollowings()
                                    await ownerModel.fetchFollowers()
                                }
                            }
                        } label: {
                            Text(isFollowing ? "Unfollow" : "Follow")
                                .font(.subheadline)
                                .padding(5)
                                .background(.black)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                                .padding(.bottom, 10)
                        }
                    }
                }
                .padding(.top, 5)
                
                Text(ownerModel.user.name)
                    .foregroundColor(.black)
                    .font(.title3)
                    .bold()
                    .padding(.top, 10)
                
                HStack(alignment: .center, spacing: 10) {
                    Text("Following")
                    Text("\(ownerModel.followings.count)")
                    Text("|")
                    Text("Follower")
                    Text("\(ownerModel.followers.count)")
                    Spacer()
                }
                .font(.caption2)
                Text("Bio")
            }
            .padding(.bottom, 10)
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $isEditInformationVisible) {
            EditInformationView(name: userModel.user.name,
                                isVisible: $isEditInformationVisible)
            .onDisappear {
                viewModel.fetchContents()
            }
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(ownerModel: PreviewStatics.userModel,
                          viewModel: PreviewStatics.profileViewModel)
        .environmentObject(PreviewStatics.userModel)
    }
}
