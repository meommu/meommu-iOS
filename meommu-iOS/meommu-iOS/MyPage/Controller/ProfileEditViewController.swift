//
//  ProfileEditViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/19.
//

import UIKit

class ProfileEditViewController: UIViewController {
    
    // 유저 정보 모델
    var userProfile: UserProfileModel?
    
    @IBOutlet weak var profileView: UIView!
    
    // 질문 레이블 프로터피
    @IBOutlet weak var kindergartenNameLabel: UILabel!
    @IBOutlet weak var representativeNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    // 입력 텍스트 필드 프로퍼티
    @IBOutlet weak var kindergartenNameTextField: UITextField!
    @IBOutlet weak var representativeNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    // 상태 확인을 위한 레이블
    @IBOutlet weak var kindergartenNameStatusLabel: UILabel!
    @IBOutlet weak var representativeNameStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfile()
        setupTextField()
    }
    
    //MARK: - 프로필 셋업 메서드
    func setupProfile() {
        profileView.setCornerRadius(30)
    }

    //MARK: - 텍스트 필드 셋업 메서드
    func setupTextField() {
        kindergartenNameTextField.text = userProfile?.kindergartenName
        representativeNameTextField.text = userProfile?.representativeName
        phoneNumberTextField.text = userProfile?.phoneNumber
    }

}
