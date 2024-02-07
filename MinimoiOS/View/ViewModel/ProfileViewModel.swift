//
//  ProfileViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/07.
//

import Foundation
import Firebase
import Combine

final class ProfileViewModel: ObservableObject {
    @Published var contents = [MinimoDTO]()
    @Published var error: Error?
    @Published var originScrollOffset: CGFloat
    @Published var newScrollOffset: CGFloat
    @Published var isLoading: Bool = false
    
    let ownerId: UUID
    let firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(ownerId: UUID, firebaseManager: FirebaseManager) {

        self.ownerId = ownerId
        self.firebaseManager = firebaseManager
        self.originScrollOffset = 0.0
        self.newScrollOffset = 0.0
        
        fetchContents()
    }
    
    func fetchContents() {
        isLoading = true
        let query = Filter.whereField("creator", isEqualTo: ownerId.uuidString)
        
        firebaseManager.readMultipleData(from: .contents, query: query, orderBy: "createdAt", descending: false)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: { contents in
                self.contents = contents.sorted { $0.createdAt > $1.createdAt }
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
}
