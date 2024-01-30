//
//  ContentsDTO.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/28.
//

import Foundation

struct MinimoDTO: Decodable, Identifiable, Hashable, Uploadable {
    var id: UUID
    var creator: UserDTO
    var createdAt: Date
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case id, creator, createdAt, content
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
        creator = try container.decode(UserDTO.self, forKey: .creator)
        createdAt = date
        content = try container.decode(String.self, forKey: .content)
    }
    
    init(id: UUID, creator: UserDTO, createdAt: Date, content: String) {
        self.id = id
        self.creator = creator
        self.createdAt = createdAt
        self.content = content
    }
    
    func dataIntoDictionary() -> [String : Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return [
            "id": self.id.uuidString,
            "creator": self.creator.dataIntoDictionary(),
            "createdAt": dateFormatter.string(from: self.createdAt),
            "content": self.content
        ]
    }
    
}
