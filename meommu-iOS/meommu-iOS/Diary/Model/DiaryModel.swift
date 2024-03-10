//
//  DiaryModel.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/18.
//

import UIKit

//MARK: - Diary 모델
// 하나로 분리
struct Diary: Codable {
    let id: Int
    let date: String
    let dogName: String
    let createdAt: String
    let imageIds: [Int]
    let title: String
    let content: String
}


//MARK: - 일기 전체 조회 모델
// 일기 전체 조회 REQ 모델
struct AllDiaryRequest: Codable {
    let year: String
    let month: String
}

// 일기 전체 조회 RES
struct AllDiaryResponse: Codable {
    let code: String
    let message: String
    let data: Data
    
    struct Data: Codable {
        let diaries: [Diary]

    }
}


//MARK: - 일기 생성 모델
// 일기 생성 REQ
struct DiaryCreateRequest: Codable {
    let date, dogName, title, content: String
    let imageIds: [Int]
}

// 일기 생성 RES
struct DiaryCreateResponse: Codable {
    let code, message: String
    let data: DataClass
    
    struct DataClass: Codable {
        let savedId: Int
    }
}

//MARK: - 일기 수정 모델
// 일기 수정 REQ
struct DiaryEditRequest: Encodable {
    let date: String
    let dogName: String
    let title: String
    let content: String
    let imageIds: [Int]
}

// 일기 수정 RES
struct DiaryEditResponse: Decodable {
    let code: String
    let message: String
    let data: String?
}

struct DiaryIdResponse: Codable {
    struct Data: Codable {
        let id: Int
        let date: String
        let dogName: String
        let createdAt: String
        let imageIds: [Int]
        let title: String
        let content: String
    }
    
    let code: String
    let message: String
    let data: Data
}

struct DeleteDiaryResponse: Decodable {
    let code: String
    let message: String
    let data: String?
}

// 일기 공유 UUID 생성 RES
struct DiaryUUIDResponse: Codable {
    let code, message: String
    let data: DataClass
    
    struct DataClass: Codable {
        let uuid: String
    }
    
}
