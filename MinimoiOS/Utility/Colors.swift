//
//  ColorSettings.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/09.
//

import Foundation
import SwiftUI

struct Colors {
    static func background(for scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return .white
        case .dark:
            return .black
        @unknown default:
            return .white
        }
    }
    
    static func minimoRow(for scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return Color(white: 0.9)
        case .dark:
            return Color(white: 0.2)
        @unknown default:
            return Color(white: 0.9)
        }
    }
    
    static func borders(for scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return .gray
        case .dark:
            return .gray
        @unknown default:
            return .gray
        }
    }
    
    static func basic(for scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return .black
        case .dark:
            return .white
        @unknown default:
            return .black
        }
    }
    
    static func highlight(for scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return .cyan
        case .dark:
            return .cyan
        @unknown default:
            return .cyan
        }
    }
}
