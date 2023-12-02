//
//  ErrorResponse.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/11/28.
//

import Foundation

struct ErrorResponse: Codable, Error {
    let code: String
    let message: String
    let data: String?
}
