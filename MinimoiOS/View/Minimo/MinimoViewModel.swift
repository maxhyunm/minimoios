//
//  MinimoViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/28.
//

import Foundation
import Firebase
import Combine

final class MinimoViewModel: ObservableObject {
    @Published var contents = [MinimoDTO]()
    @Published var error: Error?
    @Published var originScrollOffset: CGFloat
    @Published var newScrollOffset: CGFloat
    
    let user: UserDTO
    let firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(user: UserDTO, firebaseManager: FirebaseManager) {
        self.user = user
        self.firebaseManager = firebaseManager
        self.originScrollOffset = 0.0
        self.newScrollOffset = 0.0
    }
    
    func fetchContents() {
        let query = Filter.andFilter([
            Filter.whereField("creator", isEqualTo: user.id.uuidString)
        ])
        firebaseManager.readQueryData(from: "contents", query: query, orderBy: "createdAt", descending: false, limit: 20)
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
                                   creator: user.id,
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
        
        fetchContents()
    }
}
