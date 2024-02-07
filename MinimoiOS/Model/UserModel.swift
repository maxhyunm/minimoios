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
    var cancellables = Set<AnyCancellable>()
    
    init(user: UserDTO, firebaseManager: FirebaseManager) {
        self.user = user
        self.firebaseManager = firebaseManager
    }
    
    func updateName(_ name: String) {
        user.name = name
        Task {
            do {
                try await firebaseManager.updateData(from: .users, uuid: user.id, data: ["name": name])
            } catch {
                self.error = MinimoError.unknown
            }
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
                user.image = imageString.url
                user.imagePath = imageString.path
            } catch {
                self.error = MinimoError.unknown
            }
        }
        
        

    }
    
    func fetchFollowings() {
        let query = Filter.whereField("userId", isEqualTo: user.id.uuidString)
        firebaseManager
            .readMultipleData(from: .follows, query: query, orderBy: "targetId", descending: true)
            .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.error = error
            }
        } receiveValue: { follows in
            let followArray: [FollowDTO] = follows
            self.followings = followArray.map { $0.targetId }
        }
        .store(in: &cancellables)
    }
    
    func fetchFollowers() {
        let query = Filter.whereField("targetId", isEqualTo: user.id.uuidString)
        firebaseManager
            .readMultipleData(from: .follows, query: query, orderBy: "targetId", descending: true)
            .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.error = error
            }
        } receiveValue: { follows in
            let followArray: [FollowDTO] = follows
            self.followers = followArray.map { $0.targetId }
        }
        .store(in: &cancellables)
    }
    
    func follow(for targetUser: UUID) {
        guard !followings.contains(targetUser) else { return }
        followings.append(targetUser)
        let newFollow = FollowDTO(id: UUID(), userId: user.id, targetId: targetUser)
        Task { [newFollow] in
            do {
                try await firebaseManager.createData(to: .follows, data: newFollow)
            } catch {
                self.error = MinimoError.unknown
            }
        }
    }
    
    func unfollow(for targetUser: UUID) {
        guard let index = followings.firstIndex(of: targetUser) else { return }
        followings.remove(at: index)
        
        let query = Filter.andFilter([Filter.whereField("userId", isEqualTo: user.id.uuidString),
                                      Filter.whereField("targetId", isEqualTo: targetUser.uuidString)])
        firebaseManager.readSingleData(from: .follows, query: query).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.error = error
            }
        } receiveValue: { follow in
            let follow: FollowDTO = follow
            Task {
                do {
                    try await self.firebaseManager.deleteData(from: .follows, uuid: follow.id)
                } catch {
                    self.error = MinimoError.unknown
                }
            }
        }
        .store(in: &self.cancellables)
    }
}
