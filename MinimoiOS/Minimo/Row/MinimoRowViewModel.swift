//
//  TimelineRowViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/30.
//

import Foundation
import Combine

final class MinimoRowViewModel: ObservableObject {
    @Published var content: MinimoDTO
    @Published var userName: String = ""
    @Published var userImage: String = ""
    @Published var error: Error?
    let firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(content: MinimoDTO, firebaseManager: FirebaseManager) {
        self.content = content
        self.firebaseManager = firebaseManager
        fetchUserDetail()
    }
    
    func fetchUserDetail() {
        firebaseManager.readUserData(for: content.creator).sink { _ in
        } receiveValue: { user in
            self.userName = user.name
            self.userImage = user.image
        }
        .store(in: &cancellables)
    }
    
    func deleteContent() {
        firebaseManager.deleteData(from: "contents", uuid: content.id)
    }
}
