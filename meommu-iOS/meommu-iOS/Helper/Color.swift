//
//  Color.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/09.
//

import UIKit

enum Color: Int64 {
    case purple    = 1  // 8579F1
    case darkGray  = 2  // B7B7CB
    case lightGray = 3  // EBEBF0
    case green   = 4  // 63BCA9
    case black = 5
    case white = 6
    
    var textColor: UIColor {
        switch self {
        case .purple:
            return UIColor(hexCode: "#8579F1")
        case .darkGray:
            return UIColor(hexCode: "#B7B7CB")
        case .lightGray:
            return UIColor(hexCode: "#EBEBF0")
        case .green:
            return UIColor(hexCode: "#63BCA9")
        case .black:
            return UIColor(hexCode: "#1C1D22")
        case .white:
            return UIColor(hexCode: "#FFFFFF")
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .purple:
            return UIColor(hexCode: "#8579F1")
        case .darkGray:
            return UIColor(hexCode: "#B7B7CB")
        case .lightGray:
            return UIColor(hexCode: "#EBEBF0")
        case .green:
            return UIColor(hexCode: "#63BCA9")
        case .black:
            return UIColor(hexCode: "#1C1D22")
        case .white:
            return UIColor(hexCode: "#FFFFFF")
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .purple:
            return UIColor(hexCode: "#8579F1")
        case .darkGray:
            return UIColor(hexCode: "#B7B7CB")
        case .lightGray:
            return UIColor(hexCode: "#EBEBF0")
        case .green:
            return UIColor(hexCode: "#63BCA9")
        case .black:
            return UIColor(hexCode: "#1C1D22")
        case .white:
            return UIColor(hexCode: "#FFFFFF")
        }
    }
}

//MARK: - UIColor 확장 - Hex Color 사용

extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
