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
}
