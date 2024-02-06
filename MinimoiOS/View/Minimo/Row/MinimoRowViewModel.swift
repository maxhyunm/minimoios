//
//  MinimoRowViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/30.
//

import Foundation
import Combine

final class MinimoRowViewModel: ObservableObject {
    @Published var creatorId: String = ""
    @Published var creatorName: String = ""
    @Published var creatorImage: String = ""
    @Published var creatorModel: UserModel?
    @Published var error: Error?
    let firebaseManager: FirebaseManager
    let userId: String
    let content: MinimoDTO
    var cancellables = Set<AnyCancellable>()
    
    init(content: MinimoDTO, firebaseManager: FirebaseManager, userId: String) {
        self.content = content
        self.firebaseManager = firebaseManager
        self.userId = userId
        fetchCreatorDetail()
    }
    
    func fetchCreatorDetail() {
        firebaseManager.readUserData(for: content.creator).sink { _ in
        } receiveValue: { user in
            self.creatorModel = UserModel(user: user, firebaseManager: self.firebaseManager)
            self.creatorId = user.id.uuidString
            self.creatorName = user.name
            self.creatorImage = user.image
        }
        .store(in: &cancellables)
    }
    
    func deleteContent() {
        content.images.forEach { firebaseManager.deleteImage(url: $0) }
        firebaseManager.deleteData(from: "contents", uuid: content.id)
    }
}
