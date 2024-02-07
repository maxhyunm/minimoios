//
//  MinimoViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/28.
//

import Foundation
import Firebase
import Combine

final class HomeViewModel: ObservableObject {
    @Published var contents = [MinimoDTO]()
    @Published var error: Error?
    @Published var originScrollOffset: CGFloat
    @Published var newScrollOffset: CGFloat
    
    var userId: UUID
    var firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(userId: UUID, firebaseManager: FirebaseManager) {
        self.userId = userId
        self.firebaseManager = firebaseManager
        self.originScrollOffset = 0.0
        self.newScrollOffset = 0.0
    }
    
    func fetchContents(followings: [UUID]) {
        var readable = followings
        readable.append(userId)
        let query = Filter.andFilter([Filter.whereField("creator", in: readable.map { $0.uuidString })])
        
        firebaseManager.readMultipleData(from: "contents", query: query, orderBy: "createdAt", descending: false, limit: 20)
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
