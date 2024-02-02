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
    static let homeViewModel = HomeViewModel(user: user, firebaseManager: firebaseManager)
    static let profileViewModel = ProfileViewModel(user: user, profileOwnerId: user.id, firebaseManager: firebaseManager)
    static let editInformationViewModel = EditInformationViewModel(user: user, firebaseManager: firebaseManager)
    static let writeViewModel = WriteViewModel(user: user, firebaseManager: firebaseManager)
}
