////
////  MinimoViewModel.swift
////  MinimoiOS
////
////  Created by Min Hyun on 2024/02/02.
////
//
//import Foundation
//import Combine
//
//protocol MinimoModelType {
//    var contents: [MinimoDTO] { get }
//    var error: Error? { get }
//    var originScrollOffset: CGFloat { get }
//    var newScrollOffset: CGFloat { get }
//    var firebaseManager: FirebaseManager { get }
//    var cancellables: Set<AnyCancellable>  { get }
//    
//    init(firebaseManager: FirebaseManager)
//    
//    func fetchFollowingContents(of user: UUID, followings: [UUID])
//    func fetchUserContents(for user: UUID)
//}
