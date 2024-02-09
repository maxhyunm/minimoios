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
    var allContents = [MinimoDTO]()
    
    let ownerId: UUID
    let firebaseManager: FirebaseManager
    
    init(ownerId: UUID, firebaseManager: FirebaseManager) {

        self.ownerId = ownerId
        self.firebaseManager = firebaseManager
        self.originScrollOffset = 0.0
        self.newScrollOffset = 0.0
        
        fetchContents()
    }
    
    func fetchContents() {
        Task {
            await MainActor.run {
                isLoading = true
            }
        }
        
        let query = Filter.whereField("creator", isEqualTo: ownerId.uuidString)

        Task {
            let result: [MinimoDTO] = try await firebaseManager.readMultipleDataAsync(from: .contents,
                                                                                      query: query)
            await MainActor.run {
                allContents = result.sorted { $0.createdAt > $1.createdAt }
                contents = allContents
                isLoading = false
            }
        }
    }
    
    func searchContent(keyword: String) {
        if keyword == "" {
            contents = allContents
        } else {
            contents = allContents.filter { $0.content.contains(keyword) }
        }
    }
}
