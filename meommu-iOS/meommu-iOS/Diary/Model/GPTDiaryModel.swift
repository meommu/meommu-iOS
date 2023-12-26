//
//  GPTDiaryModel.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/12/26.
//

import Foundation

// MARK: - GPTDiaryModel
struct GPTDiaryGuideResponse: Codable {
    let code, message: String
    let data: GPTDataClass
}

// MARK: - GPTDataClass
struct GPTDataClass: Codable {
    let guides: [GPTGuide]
}

// MARK: - GPTGuide
struct GPTGuide: Codable {
    let id: Int
    let guide, description: String
}
