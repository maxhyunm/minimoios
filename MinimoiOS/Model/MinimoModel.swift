//
//  MinimoModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/07.
//

import Foundation
import Firebase
import Combine

final class MinimoModel: ObservableObject {
    @Published var contents = [MinimoDTO]()
    @Published var error: Error?
    @Published var originScrollOffset: CGFloat
    @Published var newScrollOffset: CGFloat
    
    let userId: UUID
    let contentsOwnerId: UUID
    let firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(userId: UUID, contentsOwnerId: UUID, firebaseManager: FirebaseManager) {
        self.userId = userId
        self.contentsOwnerId = contentsOwnerId
        self.firebaseManager = firebaseManager
        self.originScrollOffset = 0.0
        self.newScrollOffset = 0.0
        
        fetchProfileContents()
    }
    
    func fetchFollowingContents(followings: [UUID]) {
        var readable = followings
        readable.append(userId)
        let query = Filter.andFilter([Filter.whereField("creator", in: readable.map { $0.uuidString })])
        
        firebaseManager.readMultipleData(from: "contents", query: query, orderBy: "createdAt", descending: false)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: { contents in
                self.contents = contents.sorted { $0.createdAt > $1.createdAt }
            }
            .store(in: &cancellables)
    }
    
    func fetchProfileContents() {
        let query = Filter.whereField("creator", isEqualTo: contentsOwnerId.uuidString)
        
        firebaseManager.readMultipleData(from: "contents", query: query, orderBy: "createdAt", descending: false)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: { contents in
                self.contents = contents.sorted { $0.createdAt > $1.createdAt }
            }
            .store(in: &cancellables)
    }
    
    func createContent(body: String, images: [UIImage]) {
        let newId = UUID()
        
        var newContent = MinimoDTO(id: newId,
                                   creator: userId,
                                   createdAt: Date(),
                                   content: body,
                                   images: [])
        
        firebaseManager.createData(to: "contents", data: newContent)

        images.forEach { image in
            firebaseManager.saveJpegImage(image: image, collection: "contents", uuid: newId).sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: { imageString in
                newContent.images.append(imageString.url)
                newContent.imagePaths.append(imageString.path)
                self.firebaseManager.updateData(from: "contents",
                                                uuid: newId,
                                                data: ["images": newContent.images,
                                                       "imagePaths": newContent.imagePaths])
            }
            .store(in: &cancellables)
        }
    }
}
