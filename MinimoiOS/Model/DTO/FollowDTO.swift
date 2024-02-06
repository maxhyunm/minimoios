//
//  FollowDTO.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/06.
//

import Foundation

struct FollowDTO: Decodable, Identifiable, Hashable, Uploadable {
    var id: UUID
    var userId: UUID
    var followings: [UUID]
    var followers: [UUID]
    
    enum CodingKeys: String, CodingKey {
        case id, userId, followings, followers
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let uuid = UUID(uuidString: try container.decode(String.self, forKey: .id)) else {
            throw MinimoError.decodingError
        }
        
        id = uuid
        userId = try container.decode(UUID.self, forKey: .userId)
        userId = try container.decode(UUID.self, forKey: .userId)
        followings = try container.decode([UUID].self, forKey: .followings)
        followers = try container.decode([UUID].self, forKey: .followers)
    }
    
    init(id: UUID, userId: UUID, followings:[UUID] = [], followers:[UUID] = []) {
        self.id = id
        self.userId = userId
        self.followings = followings
        self.followers = followers
    }
    
    func dataIntoDictionary() -> [String : Any] {
        return [
            "id": self.id.uuidString,
            "userId": self.userId.uuidString,
            "followings": self.followings.map { $0.uuidString },
            "followers": self.followers.map { $0.uuidString }
        ]
    }
}
