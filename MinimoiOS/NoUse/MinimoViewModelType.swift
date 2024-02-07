//
//  MinimoViewModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/02.
//

import Foundation
import Combine

protocol MinimoViewModelType {
    var contents: [MinimoDTO] { get }
    var error: Error? { get }
    var originScrollOffset: CGFloat { get }
    var newScrollOffset: CGFloat { get }
    var user: UserDTO { get }
    var firebaseManager: FirebaseManager { get }
    var cancellables: Set<AnyCancellable>  { get }
    
    init(user: UserDTO, firebaseManager: FirebaseManager)
    
    func fetchContents()
}
