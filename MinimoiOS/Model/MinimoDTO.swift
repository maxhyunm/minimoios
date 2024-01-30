//
//  ContentsDTO.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/28.
//

import Foundation

struct MinimoDTO: Decodable, Identifiable, Hashable, Uploadable {
    var id: UUID
    var creator: UUID
    var createdAt: Date
    var content: String
    var images: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, creator, createdAt, content, images
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let uuid = UUID(uuidString: try container.decode(String.self, forKey: .id)),
              let date = dateFormatter.date(from: try container.decode(String.self, forKey: .createdAt)) else {
            throw MinimoError.decodingError
        }

        id = uuid
        creator = try container.decode(UUID.self, forKey: .creator)
        createdAt = date
        content = try container.decode(String.self, forKey: .content)
        images = try container.decode([String].self, forKey: .images)
    }
    
    init(id: UUID, creator: UUID, createdAt: Date, content: String, images: [String] = []) {
        self.id = id
        self.creator = creator
        self.createdAt = createdAt
        self.content = content
        self.images = images
    }
    
    func dataIntoDictionary() -> [String : Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return [
            "id": self.id.uuidString,
            "creator": self.creator.uuidString,
            "createdAt": dateFormatter.string(from: self.createdAt),
            "content": self.content,
            "images": self.images
        ]
    }
}
