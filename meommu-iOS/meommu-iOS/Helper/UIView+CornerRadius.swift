//
//  UIView+CornerRadius.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/01.
//

import UIKit

extension UIView {
    func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
