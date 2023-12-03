//
//  DiarySendModel.swift
//  meommu-iOS
//
//  Created by 이예빈 on 11/26/23.
//

import UIKit

struct DiaryRequest: Encodable {
    let date: String
    let dogName: String
    let title: String
    let content: String
    let imageIds: [Int]
}
