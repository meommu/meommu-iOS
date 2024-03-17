//
//  UITextField+addLeftPadding.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/11/26.
//

import UIKit

extension UITextField {
 func addLeftPadding() {
   let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
   self.leftView = paddingView
   self.leftViewMode = ViewMode.always
 }
    // 로그인 화면 텍스트 필드 만드는 메서드
    func makeLoginTextField(placeholder: String) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray300!])
        self.backgroundColor = .gray200
        self.textColor = .black
    }
    
    // 비밀번호 찾기 관련 텍스트 필드 만드는 메서드
    func makePasswordRecoveryTextField(placeholder: String) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray300!])
        self.backgroundColor = .gray100
        self.textColor = .black
        
        // border 설정
        self.layer.borderColor = UIColor.gray300?.cgColor
        self.layer.borderWidth = 2.0
    }
    
    
    
}
