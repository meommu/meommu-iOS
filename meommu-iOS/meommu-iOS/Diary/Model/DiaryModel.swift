//
//  DiaryModel.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/18.
//

import UIKit

// 일기 전체 조회 REQ 모델
struct AllDiaryRequest: Codable {
    let year: String
    let month: String
}

struct DiaryResponse: Codable {
    struct Data: Codable {
        struct Diary: Codable {
            let id: Int
            let date: String
            let dogName: String
            let createdAt: String
            let imageIds: [Int]
            let title: String
            let content: String
        }
        
        let diaries: [Diary]
    }
    
    let code: String
    let message: String
    let data: Data
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

struct DiaryEditRequest: Encodable {
    let date: String
    let dogName: String
    let title: String
    let content: String
    let imageIds: [Int]
}

struct DiaryEditResponse: Decodable {
    let code: String
    let message: String
    let data: String?
}
