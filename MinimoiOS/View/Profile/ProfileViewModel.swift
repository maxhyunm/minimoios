//
//  ProfileViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/02.
//

import Foundation
import Firebase
import Combine

final class ProfileViewModel: ObservableObject {
    @Published var contents = [MinimoDTO]()
    @Published var error: Error?
    @Published var originScrollOffset: CGFloat
    @Published var newScrollOffset: CGFloat
    
    var profileOwnerId: UUID
    var firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(profileOwnerId: UUID, firebaseManager: FirebaseManager) {
        self.profileOwnerId = profileOwnerId
        self.firebaseManager = firebaseManager
        self.originScrollOffset = 0.0
        self.newScrollOffset = 0.0
    }
    
    func fetchContents() {
        let query = Filter.whereField("creator", isEqualTo: profileOwnerId.uuidString)
        
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
}
