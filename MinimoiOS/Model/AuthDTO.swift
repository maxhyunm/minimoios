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
    var createdAt: Date
    var user: UUID
    
    enum CodingKeys: String, CodingKey {
        case id, email, oAuthType, createdAt, user
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let uuid = UUID(uuidString: try container.decode(String.self, forKey: .id)),
              let userId = UUID(uuidString: try container.decode(String.self, forKey: .user)),
              let oAuth = OAuthType(rawValue: try container.decode(String.self, forKey: .oAuthType)),
              let date = dateFormatter.date(from: try container.decode(String.self, forKey: .createdAt)) else {
            throw MinimoError.decodingError
        }
        
        id = uuid
        email = try container.decode(String.self, forKey: .email)
        oAuthType = oAuth
        createdAt = date
        user = userId
    }
    
    init(id: UUID, email: String, oAuthType: OAuthType, createdAt: Date, user: UUID) {
        self.id = id
        self.email = email
        self.oAuthType = oAuthType
        self.user = user
        self.createdAt = createdAt
    }
    
    func dataIntoDictionary() -> [String : Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return [
            "id": self.id.uuidString,
            "email": self.email,
            "oAuthType": self.oAuthType.rawValue,
            "user": self.user.uuidString,
            "createdAt": dateFormatter.string(from: self.createdAt)
        ]
    }
}
