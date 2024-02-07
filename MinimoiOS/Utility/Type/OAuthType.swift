//
//  OAuthProtocol.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/26.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser


enum OAuthType: String {
    case kakao = "KAKAO"
    case google = "GOOGLE"
    case unknown = "UNKNOWN"
}
