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
    var email: String
    var createdAt: Date
    var oAuthType: OAuthType
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, createdAt, oAuthType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let uuid = UUID(uuidString: try container.decode(String.self, forKey: .id)),
              let date = dateFormatter.date(from: try container.decode(String.self, forKey: .createdAt)),
              let oAuth = OAuthType(rawValue: try container.decode(String.self, forKey: .oAuthType)) else {
            throw MinimoError.decodingError
        }
        
        id = uuid
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        createdAt = date
        oAuthType = oAuth
    }
    
    init(id: UUID, name: String, email: String, createdAt: Date, oAuthType: OAuthType) {
        self.id = id
        self.name = name
        self.email = email
        self.createdAt = createdAt
        self.oAuthType = oAuthType
    }
    
    func dataIntoDictionary() -> [String : Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return [
            "id": self.id.uuidString,
            "name": self.name,
            "email": self.email,
            "createdAt": dateFormatter.string(from: self.createdAt),
            "oAuthType": self.oAuthType.rawValue
        ]
    }
    
}
