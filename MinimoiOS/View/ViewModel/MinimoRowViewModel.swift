//
//  MinimoRowViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/30.
//

import Foundation
import Firebase
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
    
    init(content: MinimoDTO, firebaseManager: FirebaseManager, userId: String) {
        self.content = content
        self.firebaseManager = firebaseManager
        self.userId = userId
        fetchCreatorDetail()
    }
    
    func fetchCreatorDetail() {
        let query = Filter.whereField("id", isEqualTo: content.creator.uuidString)
        Task {
            let user: UserDTO = try await firebaseManager.readSingleDataAsync(from: .users, query: query)
            
            await MainActor.run {
                self.creatorModel = UserModel(user: user, firebaseManager: self.firebaseManager)
                self.creatorId = user.id.uuidString
                self.creatorName = user.name
                self.creatorImage = user.image
            }
        }
    }
    
    func deleteContent() {
        for url in content.images {
            firebaseManager.deleteImage(url: url)
        }
        
        Task {
            try await firebaseManager.deleteData(from: .contents, uuid: content.id)
        }
        
    }
}
