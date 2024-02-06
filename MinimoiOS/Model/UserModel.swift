//
//  UserModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/06.
//

import Foundation

final class UserModel: ObservableObject {
    @Published var user: UserDTO
    @Published var follow: FollowDTO
    
    init(user: UserDTO, follow: FollowDTO) {
        self.user = user
        self.follow = follow
    }
}
