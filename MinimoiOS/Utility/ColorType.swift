//
//  ColorType.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/01.
//

import SwiftUI

struct ColorType {
    static let tintGradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color.cyan, Color.blue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
}
