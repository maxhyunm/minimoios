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
    @Published var owner: UserDTO
    @Published var content: MinimoDTO
    @Published var claps: [ClapDTO]
    @Published var error: Error?
    var firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(owner: UserDTO, content: MinimoDTO, claps: [ClapDTO], firebaseManager: FirebaseManager) {
        self.owner = owner
        self.content = content
        self.claps = claps
        self.firebaseManager = firebaseManager
    }
}
