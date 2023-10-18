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
    
    init(pageName: String) {
        self.pageName = pageName
        self.pageImage = UIImage(systemName: "chevron.right")
        
        // 색상 임시 지정
        self.pageImage?.withTintColor(.lightGray)
    }
    
}
