//
//  DiaryModel.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/18.
//

import UIKit


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

struct DeleteDiaryResponse: Decodable {
    let code: String
    let message: String
    let data: String?
}
