//
//  UserModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/26.
//

import Foundation

struct UserDTO: Decodable, Identifiable, Hashable, Uploadable {
    var id: UUID
    var name: String
    var image: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let uuid = UUID(uuidString: try container.decode(String.self, forKey: .id)) else {
            throw MinimoError.decodingError
        }
        
        id = uuid
        name = try container.decode(String.self, forKey: .name)
        image = try container.decode(String.self, forKey: .image)
    }
    
    init(id: UUID, name: String, image: String = "") {
        self.id = id
        self.name = name
        self.image = image
    }
    
    func dataIntoDictionary() -> [String : Any] {
        return [
            "id": self.id.uuidString,
            "name": self.name,
            "image": image
        ]
    }
    
}
