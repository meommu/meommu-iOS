//
//  String+Validation.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/11/30.
//

import Foundation

extension String {
    
    //MARK: - 이메일 형식 확인 메서드
    func isEmailFormatValid() -> Bool {
        let emailRegex = "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$"
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    //MARK: - 비밀번호 형식 확인 메서드
    func isPasswordFormatValid() -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,20}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    //MARK: - 전화번호 형식 확인 메서드
    func isPhoneNumberFormatValid() -> Bool {
           // 전화번호 정규식을 여기에 작성
           let phoneNumberRegex = "^\\d{3}-\\d{3,4}-\\d{4}"
           return NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex).evaluate(with: self)
       }
    
    //MARK: - 유치원 이름 형식 확인 메서드
    func iskindergartenNameFormatValid() -> Bool {
        let length = self.count
            return (2...13).contains(length)
    }

    //MARK: - 대표자 이름 형식 확인 메서드
    func isrepresentativeNameFormatValid() -> Bool {
        let length = self.count
            return (2...8).contains(length)
    }
    
}
