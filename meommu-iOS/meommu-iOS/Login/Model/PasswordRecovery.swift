//
//  PasswordRecovery.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/12/04.
//

import Foundation

struct PasswordRecoveryRequest {
    let email, password, passwordConfirmation: String?
}

struct PasswordRecoveryResponse: Codable {
    let code, message: String
    // 옵셔널 값으로 설정해두면 Null일 때 nil값이 된다.
    let data: Bool?
}

struct EmailCodeResponse: Codable {
    let code, message: String
    // 옵셔널 값으로 설정해두면 Null일 때 nil값이 된다.
    let data: Bool?
}

// MARK: - 비밀번호 찾기 -이메일 전송 확인 응답 데이터
//struct EmailSendResponse: Codable {
//    let code, message: String
//    // 옵셔널 값으로 설정해두면 Null일 때 nil값이 된다.
//    let data: Bool?
//}
//
//struct EmailCodeResponse: Codable {
//
//}
//
//struct PasswordResetRequest: Codable {
//
//}
