//
//  DiaryImageModel.swift
//  meommu-iOS
//
//  Created by 이예빈 on 11/26/23.
//

import Foundation

//MARK: - 이미지 다건 조회
// 이미지 다건 조회 REQ
struct ImageRequest: Codable {
    var imageIds: [Int]
}

// 이미지 다건 조회 RES
struct ImageResponse: Codable {
    let code: String
    let message: String
    let data: Data?
    
    struct Data: Codable {
        let images: [Image]
        
        struct Image: Codable {
            let id: Int
            let url: String
        }
    }
}

//MARK: - 

struct ImageUploadResponse: Codable {
    let code: String
    let message: String
    let data: ImageData

    struct ImageData: Codable {
        let images: [Image]

        struct Image: Codable {
            let id: Int
            let url: String
        }
    }
}
