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
//        fetchFollowings()
//        fetchFollowers()
    }
    
    func updateName(_ name: String) {
        user.name = name
        firebaseManager.updateData(from: "users", uuid: user.id, data: ["name": name])
    }
    
    func updateImage(_ image: UIImage) {
        if user.imagePath != "" {
            firebaseManager.deleteImage(path: user.imagePath)
        }
        firebaseManager.saveJpegImage(image: image, collection: "users", uuid: user.id).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.error = error
            }
        } receiveValue: { imageString in
            self.firebaseManager.updateData(from: "users",
                                            uuid: self.user.id,
                                            data: ["image": imageString.url, "imagePath": imageString.path])
            self.user.image = imageString.url
            self.user.imagePath = imageString.path
        }
        .store(in: &cancellables)
    }
    
    func fetchFollowings() {
        let query = Filter.whereField("userId", isEqualTo: user.id.uuidString)
        firebaseManager
            .readMultipleData(from: "follows", query: query, orderBy: "targetId", descending: true)
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
            .readMultipleData(from: "follows", query: query, orderBy: "targetId", descending: true)
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
        firebaseManager.createData(to: "follows", data: newFollow)
    }
    
    func unfollow(for targetUser: UUID) {
        guard let index = followings.firstIndex(of: targetUser) else { return }
        followings.remove(at: index)
        
        let query = Filter.andFilter([Filter.whereField("userId", isEqualTo: user.id.uuidString),
                                      Filter.whereField("targetId", isEqualTo: targetUser.uuidString)])
        firebaseManager.readSingleData(from: "follows", query: query).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.error = error
            }
        } receiveValue: { follow in
            let follow: FollowDTO = follow
            self.firebaseManager.deleteData(from: "follows", uuid: follow.id)
        }
        .store(in: &self.cancellables)
    }
}
