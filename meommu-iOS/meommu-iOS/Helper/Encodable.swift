//
//  Encodable.swift
//  meommu-iOS
//
//  Created by zaehorang on 2024/01/31.
//

import Foundation

extension Encodable {
    // Object를 Dictionary로 바꾸기
    var toDictionary : [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return nil }
        return dictionary
    }
}
