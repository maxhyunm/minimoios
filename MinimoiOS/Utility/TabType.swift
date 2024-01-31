//
//  TabType.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

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
}
