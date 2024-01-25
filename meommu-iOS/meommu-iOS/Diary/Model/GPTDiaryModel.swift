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

struct GPTDetailDataClass: Codable {
    let details: [GPTDetailGuide]
}

struct GPTDetailGuide: Codable {
    let id: Int
    let detail: String
}

//MARK: - gpt 일기 요청 모델
struct GuideDataRequest: Codable {
    var details: String
}

//MARK: - gpt 일기 응답 모델
struct GPTDiaryResponse: Codable {
    let code, message: String
    let data: DataClass
    
    // DataClass 정의
    struct DataClass: Codable {
        let content: String
    }
}

// MARK: - SSEEventResponse
struct SSEEventResponse: Codable {
    let id, object: String
    let created: Int
    let model: String
    let choices: [Choice]
    
    // MARK:  Choice
    struct Choice: Codable {
        let index: Int
        let delta: Delta
        let finishReason: String?

        enum CodingKeys: String, CodingKey {
            case index, delta
            case finishReason = "finish_reason"
        }
    }
    
    // MARK:  Delta
    struct Delta: Codable {
        let role: String?
        let content: String?
    }
    
}
