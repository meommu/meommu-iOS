//
//  Page.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/17.
//

import UIKit

// 마이 페이지에 있는 페이지 모델
struct Page {
    var pageName: String
    var pageImage: UIImage?
}

//MARK: - 세부 페이지 확장
extension Page {
    
    // 이후 페이지가 추가될 가능성을 고려하여 타입 프로퍼티로 한 번에 관리
    static let page: [Page] = [Page(pageName: "계정 관리"), Page(pageName: "공지")]
    
    // 페이지를 나타내는 셀의 이미지가 고정이기 때문에 생성자에 미리 구현
    init(pageName: String) {
        self.pageName = pageName
        self.pageImage = UIImage(systemName: "chevron.right")?.withTintColor(.lightGray)
    }
}

