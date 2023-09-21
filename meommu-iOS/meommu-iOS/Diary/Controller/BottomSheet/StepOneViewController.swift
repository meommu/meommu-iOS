//
//  StepOneViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/21.
//

import UIKit
import PanModal

class StepOneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


}

extension StepOneViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    //접혔을 때
    var shortFormHeight: PanModalHeight {
        
        return .contentHeight(103)
    }
    
    //펼쳐졌을 때
    var longFormHeight: PanModalHeight {
        //위에서부터 떨어지게 설정
        return .maxHeightWithTopInset(324)
    }
    
    // 최상단 스크롤 불가
    var anchorModalToLongForm: Bool {
        return true
    }
}
