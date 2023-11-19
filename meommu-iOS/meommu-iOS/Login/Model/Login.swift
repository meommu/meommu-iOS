//
//  Login.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/21.
//

import Foundation

//MARK: - 로그인 모델
struct LoginModel {
    var email, password: String?
}


// MARK: - 로그인 응답
struct LoginResponse: Codable {
    let code, message: String?
    let tokenData: TokenData?
    
    // 네트워크에서 주는 이름을 변환하는 방법 (원시값)
    enum CodingKeys: String, CodingKey {
        case code
        case message
        case tokenData = "Data"
    }
}

// 로그인 응답 데이터
struct TokenData: Codable {
    let accessToken: String?
}


// MARK: - 로그인 정보 조회 응답 -> 토큰으로 로그인
struct TokenVerificationResponse: Codable {
    let code, message: String?
    let loginData: LoginData?
    
    // 네트워크에서 주는 이름을 변환하는 방법 (원시값)
    enum CodingKeys: String, CodingKey {
        case code
        case message
        case loginData = "Data"
    }
}

// 로그인 정보 조회 응답 데이터
struct LoginData: Codable {
    let id: Int?
    let name, email: String?
}

