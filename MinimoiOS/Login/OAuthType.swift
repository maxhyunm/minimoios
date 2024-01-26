//
//  OAuthProtocol.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/26.
//

import SwiftUI

protocol OAuthType: ObservableObject {
    var userToken: String? { get }
    var userName: String? { get }
    var error: Error? { get }
    var isLogin: Bool { get }
    
    func handleLogin()
    func handleLogout()
}
