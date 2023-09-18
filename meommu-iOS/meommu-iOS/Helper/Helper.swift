//
//  Helper.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/09/18.
//

import Foundation


public class Storage {
    
    // UserDefaults를 이용해 앱 최초 실팽 판단 메서드
    static func isFirstTime() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirstTime") == nil {
            defaults.set("No", forKey:"isFirstTime")
            return true
        } else {
            return false
        }
    }
    
}


