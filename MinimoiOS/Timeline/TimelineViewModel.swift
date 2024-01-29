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
    let user: UUID
    let firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(user: UUID, firebaseManager: FirebaseManager) {
        self.user = user
        self.firebaseManager = firebaseManager
    }
    
    func fetchContents() {
        let query = Filter.andFilter([
            Filter.whereField("creator", isEqualTo: user.uuidString)
        ])
        firebaseManager.readQueryData(from: "contents", query: query).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.error = error
            }
        } receiveValue: { contents in
            self.contents = contents
        }
        .store(in: &cancellables)
    }
}
