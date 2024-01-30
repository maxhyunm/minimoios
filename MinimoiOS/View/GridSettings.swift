//
//  GridSettings.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import Foundation
import SwiftUI

struct GridSettings {
    static func makeVGridItems(count: Int) -> [GridItem] {
        return (0..<count).map { _ in
            GridItem(.flexible(), spacing: 5, alignment: nil)
        }
    }
    
    static func makeHGridItems(count: Int) -> [GridItem] {
        return (0..<count).map { _ in
            GridItem(.flexible(maximum: 100))
        }
    }
}
