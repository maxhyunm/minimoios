//
//  ProfileHeaderView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct ProfileHeaderView: View {
    @Environment(\.colorScheme) var colorScheme
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
    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [Colors.background(for: colorScheme),
                                            Colors.highlight(for: colorScheme),
                                            Colors.highlight(for: colorScheme)]),
                startPoint: .top,
                endPoint: .bottom)
            .frame(height: 100)
            
            VStack(alignment: .leading, spacing: 5) {
                
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
                                .background(Colors.highlight(for: colorScheme))
                                .foregroundColor(Colors.background(for: colorScheme))
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
                                .background(Colors.basic(for: colorScheme))
                                .foregroundColor(Colors.background(for: colorScheme))
                                .cornerRadius(5)
                                .padding(.bottom, 10)
                        }
                    }
                }
                .padding(.top, 50)
                
                Text(ownerModel.user.name)
                    .foregroundColor(Colors.basic(for: colorScheme))
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
                
                Text(ownerModel.user.biography)
                    .font(.callout)
                    .padding(.vertical, 5)
            }
            .padding(.bottom, 10)
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $isEditInformationVisible) {
            EditInformationView(name: userModel.user.name,
                                biography: userModel.user.biography,
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
