//
//  SignUpData.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/21.
//

import Foundation

//MARK: - 회원가입 모델
struct SignUpModel {
    var kindergartenName, representativeName, phoneNumber, email, password, confirmPassword: String?
}

// MARK: - 회원가입 응답 데이터
struct SignUpResponse: Codable {
    let code, message: String
    let data: String?
}
