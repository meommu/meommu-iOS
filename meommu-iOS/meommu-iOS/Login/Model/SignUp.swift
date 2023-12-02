//
//  SignUpData.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/21.
//

import Foundation

//MARK: - 이메일 중복 확인 요청 모델
struct CheckEmailDuplicationRequest: Codable {
    var email: String?
}

// MARK: - 이메일 중복 확인 응답 데이터
struct CheckEmailDuplicationResponse: Codable {
    let code, message: String
    // 옵셔널 값으로 설정해두면 Null일 때 nil값이 된다.
    let data: Bool?
}



//MARK: - 회원가입 요청 모델
struct SignUpRequest: Codable {
    var name, ownerName, phone, email: String?
    var password, passwordConfirmation: String?
}

// MARK: - 회원가입 응답 데이터
struct SignUpResponse: Codable {
    let code, message: String
    // 옵셔널 값으로 설정해두면 Null일 때 nil값이 된다.
    let data: SignUpDataClass?
}

struct SignUpDataClass: Codable {
    let id: Int
    let name, email, createdAt: String
}
