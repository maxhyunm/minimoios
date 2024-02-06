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
    static let follow = FollowDTO(id: UUID(uuidString: "6b34da26-ed11-4d9d-b45a-def7e0341ddb")!, userId: user.id)
    static let firebaseManager = FirebaseManager()
    static let authManager = AuthManager(firebaseManager: firebaseManager)
    static let userModel = UserModel(user: user, follow: follow)
    static let homeViewModel = HomeViewModel(userId: user.id, firebaseManager: firebaseManager)
    static let profileViewModel = ProfileViewModel(profileOwnerId: user.id, firebaseManager: firebaseManager)
    static let editInformationViewModel = EditInformationViewModel(userModel: userModel, firebaseManager: firebaseManager)
    static let writeViewModel = WriteViewModel(userId: user.id, firebaseManager: firebaseManager)
}
