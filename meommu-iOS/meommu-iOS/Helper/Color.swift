//
//  Color.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/09.
//

import UIKit

extension UIColor {
    /// #F5F6F8
    static var gray100: UIColor? { return UIColor(named: "Gray100") }
    /// #EBEBF0
    static var gray200: UIColor? { return UIColor(named: "Gray200") }
    /// #BBBBC9
    static var gray300: UIColor? { return UIColor(named: "Gray300") }
    /// #89899C
    static var gray400: UIColor? { return UIColor(named: "Gray400") }
    /// #666675
    static var gray500: UIColor? { return UIColor(named: "Gray500") }
    /// #555563
    static var gray600: UIColor? { return UIColor(named: "Gray600") }
    /// #4E4E5B
    static var gray700: UIColor? { return UIColor(named: "Gray700") }
    /// #373840
    static var gray800: UIColor? { return UIColor(named: "Gray800") }
    /// #1C1D22
    static var gray900: UIColor? { return UIColor(named: "Gray900") }
    
    /// #B7B8BA
    static var blueGray100: UIColor? { return UIColor(named: "BlueGray100") }
    /// #6F7682
    static var blueGray200: UIColor? { return UIColor(named: "BlueGray200") }
    /// #444A56
    static var blueGray300: UIColor? { return UIColor(named: "BlueGray300") }
    /// #363C48
    static var blueGray400: UIColor? { return UIColor(named: "BlueGray400") }
    /// #1B1E26
    static var blueGray500: UIColor? { return UIColor(named: "BlueGray500") }
    
    /// #8579F1
    static var primaryA: UIColor? { return UIColor(named: "primaryA") }
    /// #604FF4
    static var primaryB: UIColor? { return UIColor(named: "primaryB") }
    
    /// #FF8585
    static var error: UIColor? { return UIColor(named: "Error") }
    /// #63BCA9
    static var success: UIColor? { return UIColor(named: "Success") }
    
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
