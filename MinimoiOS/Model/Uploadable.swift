//
//  Uploadable.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import Foundation

protocol Uploadable {
    var id: UUID { get }
    
    func dataIntoDictionary() -> [String: Any]
}
