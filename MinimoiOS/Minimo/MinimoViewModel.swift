//
//  TimelineViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/28.
//

import Foundation
import Firebase
import Combine

final class MinimoViewModel: ObservableObject {
    @Published var contents = [MinimoDTO]()
    @Published var error: Error?
    let userId: UUID
    let firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(userId: UUID, firebaseManager: FirebaseManager) {
        self.userId = userId
        self.firebaseManager = firebaseManager
    }
    
    func fetchContents() {
        let query = Filter.andFilter([
            Filter.whereField("creator", isEqualTo: userId.uuidString)
        ])
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
    
    func createContents(body: String) {
        let newContent = MinimoDTO(id: UUID(),
                                   creator: userId,
                                   createdAt: Date(),
                                   content: body)
        firebaseManager.createData(to: "contents", data: newContent)
        fetchContents()
    }
}
