//
//  ClapDTO.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/06.
//

import Foundation

struct ClapDTO: Decodable, Identifiable, Hashable, Uploadable {
    var id: UUID
    var contentId: UUID
    var userId: UUID
    
    enum CodingKeys: String, CodingKey {
        case id, contentId, userId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let uuid = UUID(uuidString: try container.decode(String.self, forKey: .id)) else {
            throw MinimoError.decodingError
        }
        
        id = uuid
        contentId = try container.decode(UUID.self, forKey: .contentId)
        userId = try container.decode(UUID.self, forKey: .userId)
    }
    
    init(id: UUID, contentId: UUID, userId: UUID) {
        self.id = id
        self.contentId = contentId
        self.userId = userId
    }
    
    func dataIntoDictionary() -> [String : Any] {
        return [
            "id": self.id.uuidString,
            "contentId": self.contentId.uuidString,
            "userId": self.userId.uuidString
        ]
    }
}
