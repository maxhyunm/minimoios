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
    var userId: UUID
    
    let firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(userId: UUID, firebaseManager: FirebaseManager) {
        self.userId = userId
        self.firebaseManager = firebaseManager
        self.originScrollOffset = 0.0
        self.newScrollOffset = 0.0
        
        fetchContents()
    }
    
    func fetchContents(followings: [UUID]? = nil) {
        var query: Filter
        
        if let followings {
            var readable = followings
            readable.append(userId)
            query = Filter.andFilter([Filter.whereField("creator", in: readable.map { $0.uuidString })])
        } else {
            query = Filter.whereField("creator", isEqualTo: userId.uuidString)
        }
        
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
