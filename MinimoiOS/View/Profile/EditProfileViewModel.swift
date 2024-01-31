//
//  EditProfileViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/30.
//

import Foundation
import Firebase
import Combine

final class EditProfileViewModel: ObservableObject {
    @Published var user: UserDTO
    @Published var error: Error?
    var firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(user: UserDTO, firebaseManager: FirebaseManager) {
        self.user = user
        self.firebaseManager = firebaseManager
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
}
