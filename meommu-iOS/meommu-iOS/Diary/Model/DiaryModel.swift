//
//  DiaryModel.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/18.
//

import UIKit


struct Response: Codable {
    let code: String
    let message: String
    let data: DataClass
}

struct DataClass: Codable {
    let diaries: [Diary]
}

struct Diary: Codable {
    let id: Int
    let date: String
    let dogName: String
    let createdAt: String
    let imageIds: [Int]
    let title: String
    let content: String
}
