//
//  HomeViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/07.
//

import Foundation
import Firebase
import Combine

final class HomeViewModel: ObservableObject {
    @Published var contents = [MinimoDTO]()
    @Published var error: Error?
    @Published var originScrollOffset: CGFloat
    @Published var newScrollOffset: CGFloat
    @Published var isLoading: Bool = false
    
    let userId: UUID
    var followings: [UUID]
    let firebaseManager: FirebaseManager
    
    init(userId: UUID, followings: [UUID], firebaseManager: FirebaseManager) {
        self.userId = userId
        self.followings = followings
        self.firebaseManager = firebaseManager
        self.originScrollOffset = 0.0
        self.newScrollOffset = 0.0
        
        fetchContents()
    }
    
    func changeFollowings(_ followings: [UUID]) {
        self.followings = followings
        fetchContents()
    }
    
    func fetchContents() {
        Task {
            await MainActor.run {
                isLoading = true
            }
        }
        
        var readable = followings
        readable.append(userId)
        let query = Filter.andFilter([Filter.whereField("creator", in: readable.map { $0.uuidString })])
        
        Task {
            do {
                let result: [MinimoDTO] = try await firebaseManager.readMultipleDataAsync(from: .contents,
                                                                                          query: query)
                
                await MainActor.run {
                    contents = result.sorted { $0.createdAt > $1.createdAt }
                    isLoading = false
                }
            } catch {}
        }
    }
    
    func createContent(body: String, images: [UIImage]) {
        Task {
            await MainActor.run {
                isLoading = true
            }
        }
        
        let newId = UUID()
        let newContent = MinimoDTO(id: newId,
                                   creator: userId,
                                   createdAt: Date(),
                                   content: body,
                                   images: [])

        Task { [newContent] in
            do {
                try await firebaseManager.createData(to: .contents, data: newContent)
                try await uploadImage(for: newContent, images: images)
                fetchContents()
            } catch {}
        }
    }
    
    func uploadImage(for content: MinimoDTO, images: [UIImage]) async throws {
        var newContent = content
        
        for image in images {
            let imageString = try await firebaseManager.saveJpegImageAsync(image: image, collection: .contents, uuid: newContent.id)
            newContent.images.append(imageString.url)
            newContent.imagePaths.append(imageString.path)
            try await self.firebaseManager.updateData(from: .contents,
                                                      uuid: newContent.id,
                                                      data: ["images": newContent.images,
                                                             "imagePaths": newContent.imagePaths])
        }
    }
}
