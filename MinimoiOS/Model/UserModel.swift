//
//  UserModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/06.
//

import Foundation
import SwiftUI
import Combine
import Firebase
import FirebaseFirestoreSwift

final class UserModel: ObservableObject {
    @Published var user: UserDTO
    @Published var followings: [UUID] = []
    @Published var followers: [UUID] = []
    @Published var error: Error?
    var firebaseManager: FirebaseManager
    
    init(user: UserDTO, firebaseManager: FirebaseManager) {
        self.user = user
        self.firebaseManager = firebaseManager
        
        Task {
            await fetchFollowings()
            await fetchFollowers()
        }
    }
    
    func updateName(_ name: String) {
        user.name = name
        Task {
            do {
                try await firebaseManager.updateData(from: .users, uuid: user.id, data: ["name": name])
            } catch {}
        }
    }
    
    func updateBiography(_ biography: String) {
        user.biography = biography
        Task {
            do {
                try await firebaseManager.updateData(from: .users, uuid: user.id, data: ["biography": biography])
            } catch {}
        }
    }
    
    func updateImage(_ image: UIImage) {
        if user.image != "" {
            firebaseManager.deleteImage(url: user.image)
        }
        
        Task {
            do {
                let imageString = try await firebaseManager.saveJpegImageAsync(image: image, collection: .users, uuid: user.id)
                try await firebaseManager.updateData(from: .users,
                                                     uuid: self.user.id,
                                                     data: ["image": imageString.url, "imagePath": imageString.path])
                await MainActor.run {
                    user.image = imageString.url
                    user.imagePath = imageString.path
                }
            } catch {}
        }
    }
    
    func fetchFollowings() async  {
        do {
            let query = Filter.whereField("userId", isEqualTo: user.id.uuidString)
            
            let followArray: [FollowDTO] = try await firebaseManager.readMultipleDataAsync(from: .follows,
                                                                                           query: query)
            await MainActor.run {
                followings = followArray.map { $0.targetId }
            }
        } catch {}
    }
    
    func fetchFollowers() async  {
        do {
            let query = Filter.whereField("targetId", isEqualTo: user.id.uuidString)
            
            let followArray: [FollowDTO] = try await firebaseManager.readMultipleDataAsync(from: .follows,
                                                                                           query: query)
            await MainActor.run {
                followers = followArray.map { $0.targetId }
            }
        } catch {}
    }
    
    func follow(for targetUser: UUID) {
        guard !followings.contains(targetUser) else { return }
        followings.append(targetUser)
        let newFollow = FollowDTO(id: UUID(), userId: user.id, targetId: targetUser)
        Task { [newFollow] in
            do {
                try await firebaseManager.createData(to: .follows, data: newFollow)
            } catch {}
        }
    }
    
    func unfollow(for targetUser: UUID) {
        guard let index = followings.firstIndex(of: targetUser) else { return }
        followings.remove(at: index)
        
        let query = Filter.andFilter([Filter.whereField("userId", isEqualTo: user.id.uuidString),
                                      Filter.whereField("targetId", isEqualTo: targetUser.uuidString)])
        
        Task {
            do {
                let follow: FollowDTO = try await firebaseManager.readSingleDataAsync(from: .follows, query: query)
                try await self.firebaseManager.deleteData(from: .follows, uuid: follow.id)
            } catch {}
        }
    }
}
