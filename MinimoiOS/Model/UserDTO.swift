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
    var imagePath: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, imagePath
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let uuid = UUID(uuidString: try container.decode(String.self, forKey: .id)) else {
            throw MinimoError.decodingError
        }
        
        id = uuid
        name = try container.decode(String.self, forKey: .name)
        image = try container.decode(String.self, forKey: .image)
        imagePath = try container.decode(String.self, forKey: .imagePath)
    }
    
    init(id: UUID, name: String, image: String = "", imagePath: String = "") {
        self.id = id
        self.name = name
        self.image = image
        self.imagePath = imagePath
    }
    
    func dataIntoDictionary() -> [String : Any] {
        return [
            "id": self.id.uuidString,
            "name": self.name,
            "image": image,
            "imagePath": imagePath
        ]
    }
    
}
