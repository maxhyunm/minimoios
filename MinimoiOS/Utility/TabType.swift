//
//  TabType.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

enum TabType {
    case home
    case profile
    case search
    
    var title: String {
        switch self {
        case .home:
            return "Minimo"
        case .profile:
            return "Profile"
        case .search:
            return "Search"
        }
    }
    
    var navigationBarBackground: Color {
        switch self {
        case .home:
            return .white
        case .profile:
            return .clear
        case .search:
            return .white
        }
    }
}
