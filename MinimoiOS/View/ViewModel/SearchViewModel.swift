//
//  SearchViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/08.
//

import Foundation
import Firebase
import Combine

final class SearchViewModel: ObservableObject {
    @Published var users = [UserDTO]()
    @Published var contents = [MinimoDTO]()
    @Published var error: Error?
    @Published var originScrollOffset: CGFloat
    @Published var newScrollOffset: CGFloat
    @Published var isLoading: Bool = false
    
    let userId: UUID
    var followings: [UUID]
    let firebaseManager: FirebaseManager
    
    init(userId: UUID, followings: [UUID], firebaseManager: FirebaseManager) {
        self.userId = userId
        self.followings = followings
        self.firebaseManager = firebaseManager
        self.originScrollOffset = 0.0
        self.newScrollOffset = 0.0
    }

    func searchContents(for keyword: String) {
        Task {
            await MainActor.run {
                isLoading = true
            }
        }
        
        // TODO: string 포함하는 검색이 불가능한가?
//        let contentQuery = Filter.andFilter([Filter.whereField("content", isGreaterOrEqualTo: keyword),
//                                             Filter.whereField("content", isLessThanOrEqualTo: "\(keyword)")])
//        let userQuery = Filter.whereField("name", isGreaterOrEqualTo: keyword)
        
        let contentQuery = Filter.whereField("content", isEqualTo: keyword)
        let userQuery = Filter.whereField("name", isEqualTo: keyword)
        
        Task {
            let userResult: [UserDTO] = try await firebaseManager.readMultipleDataAsync(from: .users,
                                                                                      query: userQuery)
            let contentResult: [MinimoDTO] = try await firebaseManager.readMultipleDataAsync(from: .contents,
                                                                                             query: contentQuery)
            await MainActor.run {
                users = userResult.sorted { $0.name < $1.name }
                contents = contentResult.sorted { $0.createdAt > $1.createdAt }
                isLoading = false
            }
        }
    }
}
