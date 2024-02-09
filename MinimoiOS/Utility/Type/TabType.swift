//
//  TabType.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI


final class Tab: ObservableObject {
    @Published var current: TabType = .home
    @Published var isNavigating: Bool = false
    
    enum TabType: CaseIterable {
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
                return .white
            case .search:
                return .white
            }
        }
        
        var labelName: String {
            switch self {
            case .home:
                return "house.fill"
            case .profile:
                return "person.fill"
            case .search:
                return "magnifyingglass"
            }
        }
    }

}
