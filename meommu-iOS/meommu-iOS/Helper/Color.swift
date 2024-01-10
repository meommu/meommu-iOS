//
//  Color.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/09.
//

import UIKit

extension UIColor {
    /// #F5F6F8
    static let gray100: UIColor = UIColor(hexCode: "#F5F6F8")
    /// #EBEBF0
    static let gray200: UIColor = UIColor(hexCode: "#EBEBF0")
    /// #BBBBC9
    static let gray300: UIColor = UIColor(hexCode: "#BBBBC9")
    /// #89899C
    static let gray400: UIColor = UIColor(hexCode: "#89899C")
    /// #666675
    static let gray500: UIColor = UIColor(hexCode: "#666675")
    /// #555563
    static let gray600: UIColor = UIColor(hexCode: "#555563")
    /// #4E4E5B
    static let gray700: UIColor = UIColor(hexCode: "#4E4E5B")
    /// #373840
    static let gray800: UIColor = UIColor(hexCode: "#373840")
    /// #1C1D22
    static let gray900: UIColor = UIColor(hexCode: "#1C1D22")
    
    /// #B7B8BA
    static let blueGray100: UIColor = UIColor(hexCode: "#B7B8BA")
    /// #6F7682
    static let blueGray200: UIColor = UIColor(hexCode: "#6F7682")
    /// #444A56
    static let blueGray300: UIColor = UIColor(hexCode: "#444A56")
    /// #363C48
    static let blueGray400: UIColor = UIColor(hexCode: "#363C48")
    /// #1B1E26
    static let blueGray500: UIColor = UIColor(hexCode: "#1B1E26")
    
    /// #8579F1
    static let primaryA: UIColor = UIColor(hexCode: "#8579F1")
    /// #604FF4
    static let primaryB: UIColor = UIColor(hexCode: "#604FF4")
    
    /// #FF8585
    static let error: UIColor = UIColor(hexCode: "#FF8585")
    /// #63BCA9
    static let success: UIColor = UIColor(hexCode: "#63BCA9")
    
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
