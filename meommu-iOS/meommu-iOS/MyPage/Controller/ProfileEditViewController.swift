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
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfile()
        setupLabel()
        setupTextField()
        setupButtons()
    }
    
    //MARK: - 프로필 셋업 메서드
    func setupProfile() {
        profileView.setCornerRadius(30)
    }
    
    //MARK: - 텍스트 필드 셋업 메서드
    func setupTextField() {
        // 텍스트 필드 델리게이트 설정
        kindergartenNameTextField.delegate = self
        representativeNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        // 텍스트 필드 기존 데이터 값 할당
        kindergartenNameTextField.text = userProfile?.kindergartenName
        representativeNameTextField.text = userProfile?.representativeName
        phoneNumberTextField.text = userProfile?.phoneNumber
    }
    
    //MARK: - 상태 레이블 셋업 메서드
    func setupLabel() {
        kindergartenNameStatusLabel.text = ""
        representativeNameStatusLabel.text = ""
        
        kindergartenNameStatusLabel.textColor = .red
        representativeNameStatusLabel.textColor = .red
    }
    
    //MARK: - 버튼 셋업 메서드
    func setupButtons(){
        // 다음 버튼 색상
        nextButton.backgroundColor = Color.darkGray.buttonColor
        nextButton.setTitleColor(Color.white.textColor, for: .normal)
        
        // 다음 버튼 초기 비활성화
        nextButton.isEnabled = false
    }
    
    //MARK: - 다음 버튼 활성화 메서드
//    func updateNextButtonState() {
//
//        guard let kindergartenName = kindergartenNameTextField.text,
//              let representativeName = representativeNameTextField.text,
//              let phoneNumber = phoneNumberTextField.text
//        else {
//            return
//        }
//
//        // 조건 1: 기존 데이터에서 값이 수정되어야 함
//        if kindergartenNameTextField.text != userProfile?.kindergartenName ||
//            representativeNameTextField.text != userProfile?.representativeName ||
//            phoneNumberTextField.text != userProfile?.phoneNumber {
//
//            // 조건 2: 글자 수 제한 조건
//            if kindergartenName.count < 2 || kindergartenName.count > 13 {
//                kindergartenNameStatusLabel.text = "사용하실 수 없는 닉네임입니다."
//                nextButton.backgroundColor = Color.darkGray.buttonColor
//                nextButton.isEnabled = false
//            }
//            if representativeName.count < 2 || representativeName.count > 8 {
//                representativeNameStatusLabel.text = "사용하실 수 없는 대표자 이름입니다."
//
//                nextButton.backgroundColor = Color.darkGray.buttonColor
//                nextButton.isEnabled = false
//            }
//
//            if phoneNumber.isEmpty { // 이후에 전화번호 조건으로 교체
//                nextButton.backgroundColor = Color.darkGray.buttonColor
//                nextButton.isEnabled = false
//            }
//
//            nextButton.backgroundColor = Color.purple.buttonColor
//            nextButton.isEnabled = true
//            return
//
//
//        } else {
//            kindergartenNameStatusLabel.text = ""
//            representativeNameStatusLabel.text = ""
//            nextButton.backgroundColor = Color.darkGray.buttonColor
//            nextButton.isEnabled = false
//        }
//    }
}

//MARK: - UITextViewDelegate 확장
extension ProfileEditViewController: UITextFieldDelegate {
    //MARK: - 델리게이트 메서드 - 텍스트 필드 입력 종료 시 실행되는 메서드
    // 키보드 해제되면 텍스트 값이 바꼈는지 확인 후 버튼 활성화
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == kindergartenNameTextField && kindergartenNameTextField.text != userProfile?.kindergartenName {
            nextButton.backgroundColor = Color.purple.buttonColor
            nextButton.isEnabled = true
            return
        } else if textField == representativeNameTextField && representativeNameTextField.text != userProfile?.representativeName {
            nextButton.backgroundColor = Color.purple.buttonColor
            nextButton.isEnabled = true
            return
        } else if textField == phoneNumberTextField && phoneNumberTextField.text != userProfile?.phoneNumber {
            nextButton.backgroundColor = Color.purple.buttonColor
            nextButton.isEnabled = true
            return
        }
        nextButton.backgroundColor = Color.darkGray.buttonColor
        nextButton.isEnabled = false
    }
    
    //MARK: - 델리게이트 메서드 - 텍스트 필드 리턴 시 실행되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 다음 텍스트 필드 활성화 기능
        if textField == kindergartenNameTextField {
            kindergartenNameTextField.resignFirstResponder()
        } else if textField == representativeNameTextField {
            representativeNameTextField.resignFirstResponder()
        } else if textField == phoneNumberTextField {
            phoneNumberTextField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - 화면에 탭을 감지(UIResponder)하는 메서드 - 빈 화면 터치 시 키보드 해지
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        kindergartenNameTextField.resignFirstResponder()
        representativeNameTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
    }
    
    
}
