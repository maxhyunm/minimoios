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
    @Published var clapCount: Int = 0
    @Published var didUserClap: Bool = false
    @Published var error: Error?
    
    let firebaseManager: FirebaseManager
    let userId: String
    let content: MinimoDTO
    var claps: [String] = []
    
    init(content: MinimoDTO, firebaseManager: FirebaseManager, userId: String) {
        self.content = content
        self.firebaseManager = firebaseManager
        self.userId = userId
        
        Task {
            do {
                try await fetchCreatorData()
                try await fetchClapData()
            } catch {}
        }
    }
    
    func fetchCreatorData() async throws {
        let query = Filter.whereField("id", isEqualTo: content.creator.uuidString)
        let user: UserDTO = try await firebaseManager.readSingleDataAsync(from: .users, query: query)
        
        await MainActor.run {
            self.creatorModel = UserModel(user: user, firebaseManager: self.firebaseManager)
            self.creatorId = user.id.uuidString
            self.creatorName = user.name
            self.creatorImage = user.image
        }
    }
    
    func fetchClapData() async throws {
        let query = Filter.whereField("contentId", isEqualTo: content.id.uuidString)
        let clapArray: [ClapDTO] = try await firebaseManager.readMultipleDataAsync(from: .claps, query: query)
        
        await MainActor.run {
            claps = clapArray.map { $0.userId.uuidString }
            clapCount = claps.count
            didUserClap = claps.contains(userId)
        }
    }
    
    func deleteContent() {
        for url in content.images {
            firebaseManager.deleteImage(url: url)
        }
        
        Task {
            do {
                try await firebaseManager.deleteData(from: .contents, uuid: content.id)
            } catch {}
        }
        
    }
    
    func toggleClap() {
        if didUserClap,
            let index = claps.firstIndex(of: userId) {
            let query = Filter.andFilter([Filter.whereField("userId", isEqualTo: userId),
                                          Filter.whereField("contentId", isEqualTo: content.id.uuidString)])
            claps.remove(at: index)
            Task {
                await MainActor.run {
                    clapCount = claps.count
                    didUserClap = false
                }
                do {
                    let clap: ClapDTO = try await firebaseManager.readSingleDataAsync(from: .claps, query: query)
                    try await firebaseManager.deleteData(from: .claps, uuid: clap.id)
                } catch {}
            }
        } else {
            // 박수추가
            guard let userUuid = UUID(uuidString: userId) else { return }
            
            claps.append(userId)
            Task {
                await MainActor.run {
                    clapCount += 1
                    didUserClap = true
                }
                let clap = ClapDTO(id: UUID(), contentId: content.id, userId: userUuid)
                do {
                    try await firebaseManager.createData(to: .claps, data: clap)
                } catch {}
            }
        }
    }
}
