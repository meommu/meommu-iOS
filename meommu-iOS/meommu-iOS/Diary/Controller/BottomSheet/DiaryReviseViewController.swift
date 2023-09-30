//
//  DiaryReviseViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/30.
//

import UIKit
import PanModal

class DiaryReviseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension DiaryReviseViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    // 접혔을 때
    var shortFormHeight: PanModalHeight {
        return .contentHeight(200)
    }
    
    // 펼쳐졌을 때
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(612)
    }
    
    // 최상단 스크롤 불가
    var anchorModalToLongForm: Bool {
        return true
    }
}
