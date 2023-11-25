//
//  LoginThirdViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/09/19.
//

import UIKit

class LoginThirdViewController: UIViewController {
    // 버튼 프로퍼티
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // 입력 텍스트 필드 프로퍼티
    @IBOutlet weak var kindergartenNameTextField: UITextField!
    @IBOutlet weak var representativeNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    // 제목 레이블 프로퍼티
    @IBOutlet weak var firstMainLabel: UILabel!
    @IBOutlet weak var secondMainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    // 질문 레이블 프로터피
    @IBOutlet weak var kindergartenNameLabel: UILabel!
    @IBOutlet weak var representativeNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        setupLabel()
        setupTextFields()
        setupCornerRadius()
        setupDelegate()
        
    }
    
    //MARK: - 초기 세팅 메서드
    private func setupButton() {
        // 다음 버튼 색상
        nextButton.backgroundColor = .gray300
        nextButton.setTitleColor(.white, for: .normal)
        
        // 백 버튼 색상
        backButton.tintColor = .gray400
        
        nextButton.isEnabled = false
    }
    
    //MARK: - 레이블 셋업 메서드
    func setupLabel() {
        firstMainLabel.textColor = .gray800
        secondMainLabel.textColor = .gray800
        subLabel.textColor = .gray400
        
        kindergartenNameLabel.textColor = .gray800
        representativeNameLabel.textColor = .gray800
        phoneNumberLabel.textColor = .gray800
    }
    
    //MARK: - 텍스트 필드 셋업 메서드
    private func setupTextFields(){
        // 텍스트 필드 백그라운드 컬러 설정
        kindergartenNameTextField.backgroundColor = .gray200
        representativeNameTextField.backgroundColor = .gray200
        phoneNumberTextField.backgroundColor = .gray200
        
        // 모든 텍스트 필드의 입력 변경 이벤트에 대한 메서드 추가 - 다음 버튼 활성화
        kindergartenNameTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        representativeNameTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        phoneNumberTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    //MARK: - 코너 레디어스 값 설정 메서드
    private func setupCornerRadius() {
        nextButton.setCornerRadius(6.0)
        kindergartenNameTextField.setCornerRadius(4.0)
        representativeNameTextField.setCornerRadius(4.0)
        phoneNumberTextField.setCornerRadius(4.0)
    }
    
    //MARK: - 델리게이트 셋업 메서드
    private func setupDelegate() {
        // 텍스트 필드 delegate 설정
        kindergartenNameTextField.delegate = self
        representativeNameTextField.delegate = self
        phoneNumberTextField.delegate = self
    }
    
    //MARK: - 이전 화면 버튼
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    //MARK: - 다음 버튼 탭 메서드
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toLoginFourthVC", sender: self)
        
    }
    
    // 데이터 전달을 위해 prepare 메서드 재정의
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toLoginFourthVC" {
                let loginFourthVC = segue.destination as! LoginViewController
                loginFourthVC.kindergartenName = kindergartenNameTextField.text
            }
        }
    
}

//MARK: - UITextFieldDelegate 확장
extension LoginThirdViewController: UITextFieldDelegate {
    
    //MARK: - 다음 버튼 활성화 메서드
    private func updateNextButtonState() {
        // 다음 버튼 활성화 조건 확인
        guard let kindergartenName = kindergartenNameTextField.text, !kindergartenName.isEmpty,
              let representativeName = representativeNameTextField.text, !representativeName.isEmpty,
              let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty
        else {
            nextButton.backgroundColor = .gray300
            nextButton.isEnabled = false
            return
        }
        nextButton.backgroundColor = .prilmaryA
        nextButton.isEnabled = true
    }
    
    //MARK: - 델리게이트 메서드 - 텍스트 필드 리턴 시 실행되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == kindergartenNameTextField {
            kindergartenNameTextField.resignFirstResponder()
            representativeNameTextField.becomeFirstResponder()
        } else if textField == representativeNameTextField {
            representativeNameTextField.resignFirstResponder()
            phoneNumberTextField.becomeFirstResponder()
        } else if textField == phoneNumberTextField {
            phoneNumberTextField.resignFirstResponder()
            // 다음 버튼 활성화 확인 메서드
            updateNextButtonState()
        }
        return true
    }
    
    //MARK: - 모든 텍스트 피드 입력 동작 시 실행되는 메서드
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        updateNextButtonState()
    }
    
    //MARK: - 화면에 탭을 감지(UIResponder)하는 메서드 - 빈 화면 터치 시 키보드 해지
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        kindergartenNameTextField.resignFirstResponder()
        representativeNameTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        
        // 다음 버튼 활성화 확인 메서드
        updateNextButtonState()
    }
}

