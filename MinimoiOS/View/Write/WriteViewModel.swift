//
//  WriteViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/02.
//

import Foundation
import Firebase
import Combine

final class WriteViewModel: ObservableObject {
    @Published var error: Error?
    let user: UserDTO
    let firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(user: UserDTO, firebaseManager: FirebaseManager) {
        self.user = user
        self.firebaseManager = firebaseManager
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
    }
}
