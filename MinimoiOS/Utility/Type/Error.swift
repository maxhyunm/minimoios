//
//  Error.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/28.
//

enum MinimoError: Error {
    case decodingError
    case fileNotFound
    case dataNotFound
    case invalidImage
    case unknown
    
    var title: String {
        switch self {
        case .decodingError:
            return "변환 오류"
        case .fileNotFound:
            return "파일 오류"
        case .dataNotFound:
            return "데이터 오류"
        case .invalidImage:
            return "이미지 오류"
        case .unknown:
            return "오류"
        }
    }
    var message: String {
        switch self {
        case .decodingError:
            return "데이터 변환 오류입니다"
        case .fileNotFound:
            return "파일을 찾을 수 없습니다"
        case .dataNotFound:
            return "데이터를 찾을 수 없습니다"
        case .invalidImage:
            return "잘못된 이미지 형식입니다"
        case .unknown:
            return "알 수 없는 오류입니다"
        }
    }
}
