//
//  DiaryGuideWirtePageViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/12/16.
//

import UIKit
import PanModal

class DiaryGuideWirtePageViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // 1. 초기
    
    
    
    
}

//MARK: - PanModalPresentable 확장 코드
extension DiaryGuideWirtePageViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    // 짧은 형태의 높이 설정
    var shortFormHeight: PanModalHeight {
        return .contentHeight(510)  // 바텀 시트의 높이 설정
    }
    
    // 상단 코너를 둥글게 설정
    var shouldRoundTopCorners: Bool {
        return true
    }
    
    // 상단 코너의 반경을 설정
    var cornerRadius: CGFloat {
        return 20.0  // 둥근 모서리 설정
    }
    
    // 최상단 스크롤 불가
    var anchorModalToLongForm: Bool {
        return false
    }
}
