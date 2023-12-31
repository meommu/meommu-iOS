//
//  DiaryImageModel.swift
//  meommu-iOS
//
//  Created by 이예빈 on 11/26/23.
//

import UIKit

struct ImageResponse: Codable {
    
    struct Data: Codable {
        struct Image: Codable {
            let id: Int
            let url: String
        }

        let images: [Image]
    }

    let code: String
    let message: String
    let data: Data?
}

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
