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
    var oAuthType: OAuthType
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, oAuthType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let uuid = UUID(uuidString: try container.decode(String.self, forKey: .id)),
              let oAuth = OAuthType(rawValue: try container.decode(String.self, forKey: .oAuthType)) else {
            throw MinimoError.decodingError
        }
        
        id = uuid
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        oAuthType = oAuth
    }
    
    init(id: UUID, name: String, email: String, oAuthType: OAuthType) {
        self.id = id
        self.name = name
        self.email = email
        self.oAuthType = oAuthType
    }
    
    func dataIntoDictionary() -> [String : Any] {
        return [
            "id": self.id.uuidString,
            "name": self.name,
            "email": self.email,
            "oAuthType": self.oAuthType.rawValue
        ]
    }
    
}
