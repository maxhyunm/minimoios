//
//  ContentsDTO.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/28.
//

import Foundation

struct ContentsDTO: Codable {
    var id: String
    var creator: String
    var createdAt: Date
    var body: String
}
