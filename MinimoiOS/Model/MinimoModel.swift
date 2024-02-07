//
//  MinimoModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/07.
//

import Foundation
import Firebase
import Combine

final class MinimoModel: ObservableObject, MinimoModelType {
    @Published var contents = [MinimoDTO]()
    @Published var error: Error?
    @Published var originScrollOffset: CGFloat
    @Published var newScrollOffset: CGFloat
    
    let firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
        self.originScrollOffset = 0.0
        self.newScrollOffset = 0.0
    }
    
    func fetchFollowingContents(of user: UUID, followings: [UUID]) {
        var readable = followings
        readable.append(user)
        let query = Filter.andFilter([Filter.whereField("creator", in: readable.map { $0.uuidString })])
        
        firebaseManager.readMultipleData(from: "contents", query: query, orderBy: "createdAt", descending: false)
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
    
    func fetchUserContents(for user: UUID) {
        let query = Filter.whereField("creator", isEqualTo: user.uuidString)
        
        firebaseManager.readMultipleData(from: "contents", query: query, orderBy: "createdAt", descending: false)
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
