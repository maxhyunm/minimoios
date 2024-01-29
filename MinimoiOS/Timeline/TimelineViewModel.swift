//
//  TimelineViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/28.
//

import Foundation
import Firebase
import Combine

final class TimelineViewModel: ObservableObject {
    @Published var contents = [ContentDTO]()
    @Published var error: Error?
    let user: UserDTO
    let firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(user: UserDTO, firebaseManager: FirebaseManager) {
        self.user = user
        self.firebaseManager = firebaseManager
    }
    
    func fetchContents() {
        let query = Filter.andFilter([
            Filter.whereField("creator", isEqualTo: user.id.uuidString)
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
    
    func createContents(content: String) {
        let newContent = ContentDTO(id: UUID(),
                                    creator: user.id,
                                    name: user.name,
                                    createdAt: Date(),
                                    content: content)
        firebaseManager.createData(to: "contents", data: newContent)
        fetchContents()
    }
}
