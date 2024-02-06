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
    @Published var ownerModel: UserModel
    
    let firebaseManager: FirebaseManager
    var cancellables = Set<AnyCancellable>()
    
    init(ownerModel: UserModel, firebaseManager: FirebaseManager) {
        self.ownerModel = ownerModel
        self.firebaseManager = firebaseManager
        self.originScrollOffset = 0.0
        self.newScrollOffset = 0.0
        
        fetchContents()
    }
    
    func fetchContents() {
        let query = Filter.whereField("creator", isEqualTo: ownerModel.user.id.uuidString)
        
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
