//
//  CollectionType.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/07.
//

import Foundation

enum Collection {
    case auth
    case users
    case contents
    case follows
    case claps
    
    var name: String {
        switch self {
        case .auth:
            return "auth"
        case .users:
            return "users"
        case .contents:
            return "contents"
        case .follows:
            return "follows"
        case .claps:
            return "claps"
        }
    }
    
    var fields: [String] {
        switch self {
        case .auth:
            return AuthDTO.fields
        case .users:
            return UserDTO.fields
        case .contents:
            return MinimoDTO.fields
        case .follows:
            return FollowDTO.fields
        case .claps:
            return ClapDTO.fields
        }
    }
}
