//
//  PasswordRecoveryThirdViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/11/26.
//

import UIKit

class PasswordRecoveryThirdViewController: UIViewController {
    
    // 이전 화면에서 받아올 이메일
    var email: String?
    
    // 버튼 프로퍼티
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        setupTextField()
        setupCornerRadius()
        setupDelegate()
    }
    
    //MARK: - 버턴 셋업 메서드
    private func setupButton() {
        // 다음 버튼 색상
        nextButton.backgroundColor = .gray300
        nextButton.setTitleColor(.white, for: .normal)
        
        // 백 버튼 색상
        backButton.tintColor = .gray400
        
        nextButton.isEnabled = false
    }
    
    //MARK: - 텍스트 필드 셋업 메서드
    func setupTextField() {
        passwordTextField.backgroundColor = .gray100
        passwordTextField.addLeftPadding()
        
        // border 설정
        passwordTextField.layer.borderColor = UIColor.gray300.cgColor
        passwordTextField.layer.borderWidth = 2.0
        
        // 모든 텍스트 필드의 입력 변경 이벤트에 대한 메서드 추가 - 다음 버튼 활성화
        passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    //MARK: - 코너 레디어스 값 설정 메서드
    private func setupCornerRadius() {
        nextButton.setCornerRadius(6.0)
        passwordTextField.setCornerRadius(4.0)
    }
    
    //MARK: - 델리게이트 셋업 메서드
    private func setupDelegate() {
        // textField 델리게이트 설정
        passwordTextField.delegate = self
    }
    
    //MARK: - 이전 버튼 탭 메서드
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    //MARK: - 다음 버튼 탭 메서드

    @IBAction func nextButtonTapped(_ sender: Any) {
        
        nextButton.makeLoadingButton()
        
        guard let password = passwordTextField.text, password.isPasswordFormatValid() else {
            nextButton.makeEnabledButton()
            
            // 오류 발생 시 토스트 얼럿으로 메시지를 보여줌.
            ToastManager.showToastAboveTextField(message: "비밀번호 형식이 올바르지 않습니다", font: .systemFont(ofSize: 16, weight: .medium), aboveTextField: passwordTextField, in: self)
            
            return
        }
        
        
        
        self.performSegue(withIdentifier: "toPasswordRecoveryFourthVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPasswordRecoveryFourthVC" {
            let passwordRecoveryFourthVC = segue.destination as! PasswordRecoveryFourthViewController
            
            passwordRecoveryFourthVC.email = self.email
            passwordRecoveryFourthVC.password = passwordTextField.text
        }
    }
    
 
    override func viewWillDisappear(_ animated: Bool) {
        nextButton.makeEnabledButton()
    }
}

//MARK: - UITextFieldDelegate 확장
extension PasswordRecoveryThirdViewController: UITextFieldDelegate {
    //MARK: - 다음 버튼 활성화 메서드
    private func updateNextButtonState() {
        // 다음 버튼 활성화 조건 확인
        guard let password = passwordTextField.text, !password.isEmpty
        else {
            nextButton.backgroundColor = .gray300
            nextButton.isEnabled = false
            return
        }
        nextButton.backgroundColor = .primaryA
        nextButton.isEnabled = true
    }
    
    //MARK: - 델리게이트 메서드 - 텍스트 필드 리턴 시 실행되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 키보드 내리기
        textField.resignFirstResponder()
        
        // 다음 버튼 활성화 확인 메서드
        updateNextButtonState()
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
        passwordTextField.resignFirstResponder()
        
        // 다음 버튼 활성화 확인 메서드
        updateNextButtonState()
    }
}
