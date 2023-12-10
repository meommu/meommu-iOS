//
//  UserProfile.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/21.
//

import Foundation

//MARK: -  유저 정보 모델
struct UserProfileModel {
    var kindergartenName, representativeName, phoneNumber, email: String?
}

// MARK: - 유저 정보 조회 응답
struct UserProfileResponse: Codable {
    let code, message: String
    let userProfileData: UserProfileData?
    
    // 네트워크에서 주는 이름을 변환하는 방법 (원시값)
    enum CodingKeys: String, CodingKey {
        case code
        case message
        case userProfileData = "data"
    }
}
// 유저 정보 조회 응답 데이터
struct UserProfileData: Codable {
    let id, name, ownerName, phone, email: String?
}

struct UserProfileUpdateRequest: Codable {
    let name, ownerName, phone: String?
}

//MARK: - 회원 정보 수정 응답
struct UserProfileUpdateResponse: Codable {
    let code, messagem, data: String?
}

//MARK: - 회원 탈퇴 응답
struct UserWithdrawalResponse: Codable {
    let code, message, data: String?
}
