//
//  AuthDTO.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/30.
//

import Foundation

struct AuthDTO: Decodable, Identifiable, Hashable, Uploadable {
    var id: UUID
    var email: String
    var oAuthType: OAuthType
    var user: UUID
    
    enum CodingKeys: String, CodingKey {
        case id, email, oAuthType, user
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let uuid = UUID(uuidString: try container.decode(String.self, forKey: .id)),
              let userId = UUID(uuidString: try container.decode(String.self, forKey: .user)),
              let oAuth = OAuthType(rawValue: try container.decode(String.self, forKey: .oAuthType)) else {
            throw MinimoError.decodingError
        }
        
        id = uuid
        email = try container.decode(String.self, forKey: .email)
        oAuthType = oAuth
        user = userId
    }
    
    init(id: UUID, email: String, oAuthType: OAuthType, user: UUID) {
        self.id = id
        self.email = email
        self.oAuthType = oAuthType
        self.user = user
    }
    
    func dataIntoDictionary() -> [String : Any] {
        return [
            "id": self.id.uuidString,
            "email": self.email,
            "oAuthType": self.oAuthType.rawValue,
            "user": self.user.uuidString
        ]
    }
}
