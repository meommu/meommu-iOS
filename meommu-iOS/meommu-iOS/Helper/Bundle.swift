//
//  Bundle.swift
//  meommu-iOS
//
//  Created by zaehorang on 3/16/24.
//

import Foundation

extension Bundle {
    var baseURL: String? {
        return infoDictionary?["BASE_URL"] as? String
    }
}
