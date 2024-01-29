//
//  ContentsDTO.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/28.
//

import Foundation

struct ContentsDTO: Decodable, Identifiable, Hashable, Uploadable {
    var id: UUID
    var creator: UUID
    var name: String
    var createdAt: Date
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case id, creator, name, createdAt, content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let uuid = UUID(uuidString: try container.decode(String.self, forKey: .id)),
              let creatorId = UUID(uuidString: try container.decode(String.self, forKey: .creator)),
              let date = dateFormatter.date(from: try container.decode(String.self, forKey: .createdAt)) else {
            throw MinimoError.decodingError
        }
        
        id = uuid
        creator = creatorId
        name = try container.decode(String.self, forKey: .name)
        createdAt = date
        content = try container.decode(String.self, forKey: .content)
    }
    
    func dataIntoDictionary() -> [String : Any] {
        return [
            "id": self.id.uuidString,
            "creator": self.creator.uuidString,
            "name": self.name,
            "createdAt": self.createdAt,
            "content": self.content
        ]
    }
    
}
