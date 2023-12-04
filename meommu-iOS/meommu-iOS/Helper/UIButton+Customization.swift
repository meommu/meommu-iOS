//
//  UIButton+Customization.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/12/05.
//

import UIKit

extension UIButton {
    // 버튼을 활성화 상태로 만드는 메서드
    func makeEnabledButton() {
        self.backgroundColor = .primaryA
        self.isEnabled = true
    }
    
    // 버튼을 비활성화 상태로 만드는 메서드
    func makeDisabledButton() {
        self.backgroundColor = .gray300
        self.isEnabled = false
    }
    
    // 버튼을 로딩 중인 상태로 만드는 메서드
    func makeLoadingButton() {
        self.backgroundColor = .primaryB
        self.isEnabled = false
    }
}
