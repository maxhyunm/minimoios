//
//  SearchTab.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/08.
//

import Foundation

enum SearchTab: CaseIterable {
    case contents
    case users
    
    var title: String {
        switch self {
        case .contents:
            return "Minimo"
        case .users:
            return "User"
        }
    }
}
