//
//  NetworkManager.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/28.
//

import Foundation

class DecodingManager {
    static let shared = DecodingManager()
    let decoder = JSONDecoder()
    
    private init() {}
    
    func loadFile<T: Decodable>(_ file: String) throws -> T {
        guard let file = Bundle.main.url(forResource: file, withExtension: nil) else {
            throw MinimoError.fileNotFound
        }
        
        let data = try Data(contentsOf: file)
        
        return try decode(data)
    }
    
    func decode<T: Decodable>(_ data: Data) throws -> T {
        return try decoder.decode(T.self, from: data)
    }
}

