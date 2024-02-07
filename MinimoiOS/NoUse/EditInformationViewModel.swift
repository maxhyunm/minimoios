//
//  EditProfileViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/30.
//

import Foundation
import Firebase
import Combine

final class EditInformationViewModel: ObservableObject {
    let userModel: UserModel
    @Published var error: Error?
    var firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(userModel: UserModel, firebaseManager: FirebaseManager) {
        self.userModel = userModel
        self.firebaseManager = firebaseManager
    }
    
    func updateName(_ name: String) {
        userModel.user.name = name
        firebaseManager.updateData(from: "users", uuid: userModel.user.id, data: ["name": name])
    }
    
    func updateImage(_ image: UIImage) {
        if userModel.user.image != "" {
            firebaseManager.deleteImage(url: userModel.user.imagePath)
        }
        
        firebaseManager.saveJpegImage(image: image, collection: "users", uuid: userModel.user.id).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.error = error
            }
        } receiveValue: { imageString in
            self.firebaseManager.updateData(from: "users",
                                            uuid: self.userModel.user.id,
                                            data: ["image": imageString.url, "imagePath": imageString.path])
            self.userModel.user.image = imageString.url
            self.userModel.user.imagePath = imageString.path
        }
        .store(in: &cancellables)
    }
}
