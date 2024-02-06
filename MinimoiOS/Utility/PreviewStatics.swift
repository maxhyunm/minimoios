//
//  PreviewStatics.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/02.
//

import Foundation

struct PreviewStatics {
    static let user = UserDTO(
        id: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
        name: "테스트"
    )
    static let firebaseManager = FirebaseManager()
    static let authManager = AuthManager(firebaseManager: firebaseManager)
    static let userModel = UserModel(user: user, firebaseManager: firebaseManager)
    static let homeViewModel = HomeViewModel(userId: user.id, firebaseManager: firebaseManager)
    static let profileViewModel = ProfileViewModel(ownerModel: userModel, firebaseManager: firebaseManager)
    static let editInformationViewModel = EditInformationViewModel(userModel: userModel, firebaseManager: firebaseManager)
    static let writeViewModel = WriteViewModel(userId: user.id, firebaseManager: firebaseManager)
}
