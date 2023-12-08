//
//  Announcement.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/11/09.
//

import UIKit

struct Announcment {
    var title: String
    var content: String
    // 공지사항 처음 상태를 제목만 보여주기 위함.
    var isContentHidden = true
}

// MARK: - Announcment
struct AnnouncmentResponse: Codable {
    let code, message: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let notices: [Notice]
}

// MARK: - Notice
struct Notice: Codable {
    let id: Int
    let title, content, createdAt: String
}
