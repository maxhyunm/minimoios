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
    var targetId: UUID
    
    enum CodingKeys: String, CodingKey {
        case id, userId, targetId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let uuid = UUID(uuidString: try container.decode(String.self, forKey: .id)) else {
            throw MinimoError.decodingError
        }
        
        id = uuid
        userId = try container.decode(UUID.self, forKey: .userId)
        targetId = try container.decode(UUID.self, forKey: .targetId)
    }
    
    init(id: UUID, userId: UUID, targetId: UUID) {
        self.id = id
        self.userId = userId
        self.targetId = targetId
    }
    
    func dataIntoDictionary() -> [String : Any] {
        return [
            "id": self.id.uuidString,
            "userId": self.userId.uuidString,
            "targetId": self.targetId.uuidString
        ]
    }
    
    static let fields: [String] = ["id", "userId", "targetId"]
}
