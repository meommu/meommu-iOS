//
//  PasswordRecoveryFirstViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/11/26.
//

import UIKit

class PasswordRecoveryFirstViewController: UIViewController {
    
    // 레이블 프로퍼티
    @IBOutlet weak var firstMainLabel: UILabel!
    @IBOutlet weak var secondMainLabel: UILabel!
    
    // 버튼 프로퍼티
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        setupLabel()
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
    
    //MARK: - 레이블 셋업 메서드
    private func setupLabel() {
        firstMainLabel.textColor = .gray900
        secondMainLabel.textColor = .gray900
    }
    
    //MARK: - 텍스트 필드 셋업 메서드
    func setupTextField() {
        emailTextField.makePasswordRecoveryTextField(placeholder: "이메일")
        emailTextField.addLeftPadding()
        
        // 모든 텍스트 필드의 입력 변경 이벤트에 대한 메서드 추가 - 다음 버튼 활성화
        emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    //MARK: - 코너 레디어스 값 설정 메서드
    private func setupCornerRadius() {
        nextButton.setCornerRadius(6.0)
        emailTextField.setCornerRadius(4.0)
    }

    //MARK: - 델리게이트 셋업 메서드
    private func setupDelegate() {
        // textField 델리게이트 설정
        emailTextField.delegate = self
    }
    
    //MARK: - 이전 화면 버튼
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        // 비동기 처리 중을 나타냄.
        nextButton.makeLoadingButton()
        
        let passwordRecoveryService = PasswordRecoveryService()
        
        guard let email = emailTextField.text else { return }
        
        // 이메일을 서버로 전송
        passwordRecoveryService.sendEmail(with: email) { result in
            switch result {
            case .success(let response):
                self.checkEmailResponse(response)
                print(#function)
            case .failure(let error):
                // 400~500 에러
                print("Error: \(error.message)")
            }
            
            self.nextButton.makeEnabledButton()
        }
        
    }
    
    private func checkEmailResponse(_ response: PasswordRecoveryResponse) {
        if response.code == "0000" {
            self.performSegue(withIdentifier: "toPasswordRecoverySecondVC", sender: self)
        } else {
            // 오류 발생 시 토스트 얼럿으로 메시지를 보여줌.
            ToastManager.showToastAboveTextField(message: response.message, font: .systemFont(ofSize: 16, weight: .medium), aboveTextField: emailTextField, textFieldTopMargin: 13, in: self)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPasswordRecoverySecondVC" {
            let passwordRecoverySecondVC = segue.destination as! PasswordRecoverySecondViewController
            
            passwordRecoverySecondVC.email = emailTextField.text
        }
    }
    
}




//MARK: - UITextFieldDelegate 확장
extension PasswordRecoveryFirstViewController: UITextFieldDelegate {
    
    //MARK: - 다음 버튼 활성화 메서드
    private func updateNextButtonState() {
        // 다음 버튼 활성화 조건 확인
        guard let email = emailTextField.text, !email.isEmpty, email.isEmailFormatValid()
        else {
            // 다음 버튼 비활성화
            nextButton.backgroundColor = .gray300
            nextButton.isEnabled = false
            return
        }
        // 다음 버튼 활성화
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
        emailTextField.resignFirstResponder()
        
        // 다음 버튼 활성화 확인 메서드
        updateNextButtonState()
    }

}
