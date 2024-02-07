////
////  MinimoModel.swift
////  MinimoiOS
////
////  Created by Min Hyun on 2024/02/07.
////
//
//import Foundation
//import Firebase
//import Combine
//
//final class MinimoModel: ObservableObject {
//    @Published var contents = [MinimoDTO]()
//    @Published var error: Error?
//    @Published var originScrollOffset: CGFloat
//    @Published var newScrollOffset: CGFloat
//    
//    let userId: UUID
//    let contentsOwnerId: UUID
//    let firebaseManager: FirebaseManager
//    var cancellables = Set<AnyCancellable>()
//    
//    init(userId: UUID, contentsOwnerId: UUID, firebaseManager: FirebaseManager) {
//        self.userId = userId
//        self.contentsOwnerId = contentsOwnerId
//        self.firebaseManager = firebaseManager
//        self.originScrollOffset = 0.0
//        self.newScrollOffset = 0.0
//        
//        fetchProfileContents()
//    }
//    
//    func fetchFollowingContents(followings: [UUID]) {
//        var readable = followings
//        readable.append(userId)
//        let query = Filter.andFilter([Filter.whereField("creator", in: readable.map { $0.uuidString })])
//        
//        firebaseManager.readMultipleData(from: .contents, query: query, orderBy: "createdAt", descending: false)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    self.error = error
//                }
//            } receiveValue: { contents in
//                self.contents = contents.sorted { $0.createdAt > $1.createdAt }
//            }
//            .store(in: &cancellables)
//    }
//    
//    func fetchProfileContents() {
//        let query = Filter.whereField("creator", isEqualTo: contentsOwnerId.uuidString)
//        
//        firebaseManager.readMultipleData(from: .contents, query: query, orderBy: "createdAt", descending: false)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    self.error = error
//                }
//            } receiveValue: { contents in
//                self.contents = contents.sorted { $0.createdAt > $1.createdAt }
//            }
//            .store(in: &cancellables)
//    }
//    
//    func createContent(body: String, images: [UIImage], tabType: Tab.TabType) {
//        let newId = UUID()
//        let newContent = MinimoDTO(id: newId,
//                                   creator: userId,
//                                   createdAt: Date(),
//                                   content: body,
//                                   images: [])
//        
//        Task { [newContent] in
//            do {
//                try await firebaseManager.createData(to: .contents, data: newContent)
//                try await uploadImage(for: newContent, images: images)
//
//            } catch {
//                self.error = MinimoError.unknown
//            }
//        }
//    }
//    
//    func uploadImage(for content: MinimoDTO, images: [UIImage]) async throws {
//        var newContent = content
//        
//        for image in images {
//            let imageString = try await firebaseManager.saveJpegImageAsync(image: image, collection: .contents, uuid: newContent.id)
//            newContent.images.append(imageString.url)
//            newContent.imagePaths.append(imageString.path)
//            try await self.firebaseManager.updateData(from: .contents,
//                                                      uuid: newContent.id,
//                                                      data: ["images": newContent.images,
//                                                             "imagePaths": newContent.imagePaths])
//        }
//    }
//}
