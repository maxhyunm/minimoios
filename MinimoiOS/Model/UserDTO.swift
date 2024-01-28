//
//  UserModel.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/26.
//

import Foundation

struct UserDTO: Codable {
    var id: String
    var name: String
    var email: String
    var oAuthType: String
}
