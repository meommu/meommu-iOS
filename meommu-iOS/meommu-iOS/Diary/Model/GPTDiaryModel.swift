//
//  GPTDiaryModel.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/12/26.
//

import Foundation

// MARK: - GPTDiaryGuide Model
struct GPTDiaryGuideResponse: Codable {
    let code, message: String
    let data: GPTDataClass
}

struct GPTDataClass: Codable {
    let guides: [GPTGuide]
}

struct GPTGuide: Codable {
    let id: Int
    let guide, description: String
}


//MARK: - GPTDiaryDetailGuide Model
struct GPTDiaryDetailGuideResponse: Codable {
    let code, message: String
    let data: GPTDetailDataClass
}

// MARK: - DataClass
struct GPTDetailDataClass: Codable {
    let details: [GPTDetailGuide]
}

// MARK: - Detail
struct GPTDetailGuide: Codable {
    let id: Int
    let detail: String
}


