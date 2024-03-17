//
//  PasswordRecoveryFourthViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/11/26.
//

import UIKit

class PasswordRecoveryFourthViewController: UIViewController {
    
    // 레이블 프로퍼티
    @IBOutlet weak var firstMainLabel: UILabel!
    @IBOutlet weak var secondMainLabel: UILabel!
    
    // 이전 화면 이메일 데이터 저장 프로퍼티
    var email: String?
    
    // 이전 화면 비밀번호 데이터 저장 프로퍼티
    var password: String?
    
    // 버튼 프로퍼티
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // 비밀번호 조건 레이블
    @IBOutlet weak var passwordRequirementsLabel: UILabel!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        setupLabel()
        setupTextField()
        setupCornerRadius()
        setupDelegate()
    }
    
    //MARK: - 버튼 셋업 메서드
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
        passwordRequirementsLabel.textColor = .gray400
    }
    
    //MARK: - 텍스트 필드 셋업 메서드
    func setupTextField() {
        confirmPasswordTextField.makePasswordRecoveryTextField(placeholder: "비밀번호")
        confirmPasswordTextField.addLeftPadding()
        
        // 모든 텍스트 필드의 입력 변경 이벤트에 대한 메서드 추가 - 다음 버튼 활성화
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    //MARK: - 코너 레디어스 값 설정 메서드
    private func setupCornerRadius() {
        nextButton.setCornerRadius(6.0)
        
        confirmPasswordTextField.setCornerRadius(4.0)
    }
    
    //MARK: - 델리게이트 셋업 메서드
    private func setupDelegate() {
        // textField 델리게이트 설정
        confirmPasswordTextField.delegate = self
    }
    
    //MARK: - 이전 화면 탭 버튼
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    //MARK: - 다음 버튼 탭 메서드
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        
        guard let email = self.email, let password = self.password, let confirmPassword = confirmPasswordTextField.text else { return }
        
        let passwordRecoveryService = PasswordRecoveryService()
        let request = PasswordRecoveryRequest(password: password, passwordConfirmation: confirmPassword)
        
        // 버튼 로딩 색상
        nextButton.makeLoadingButton()
        
        // 이전 화면에서 입력한 비밀번호와 같은 것이 입력되었는지 확인
        if password != confirmPasswordTextField.text {
            // 오류 발생 시 토스트 얼럿으로 메시지를 보여줌.
            ToastManager.showToastAboveTextField(message: "비밀번호가 일치하지 않습니다", font: .systemFont(ofSize: 16, weight: .medium), aboveTextField: confirmPasswordTextField, textFieldTopMargin: 13, in: self)

        } else {
            // 비밀번호 변경 REQ 메서드
            passwordRecoveryService.changePassword(email: email, request: request) { result in
                switch result {
                case .success(let response):
                    if response.code == "0000" {
                        self.changeRootViewToLogin()
                    } else {
                        // 오류 발생 시 메시지를 토스트로 보여줌.
                        ToastManager.showToastAboveTextField(message: response.message, font: .systemFont(ofSize: 16, weight: .medium), aboveTextField: self.confirmPasswordTextField, textFieldTopMargin: 13, in: self)
                    }
                case .failure(let error):
                    // 400~500 에러
                    print("Error: \(error.message)")
                }
            }
        }
        
    }
    
    // 루트 뷰를 로그인 화면으로 변경하는 메서드
    private func changeRootViewToLogin() {
        // 로그인하고 일기 화면으로 rootView 변경
        let newStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let newViewController = newStoryboard.instantiateViewController(identifier: "LoginFirstViewController") as! LoginFirstViewController
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        
        sceneDelegate.changeRootViewController(newViewController, animated: true)
        
        // 로그인 화면에서 비밀번호 변견 완료를 알리는 토스트 얼럿
        ToastManager.showToastBelowTextField(message: "비밀번호가 변경 되었습니다", font: .systemFont(ofSize: 16, weight: .medium), belowTextField: newViewController.emailTextField, textFieldBottomMargin: 35, in: newViewController)
    }
}







//MARK: - UITextFieldDelegate 확장
extension PasswordRecoveryFourthViewController: UITextFieldDelegate {
    //MARK: - 다음 버튼 활성화 메서드
    private func updateNextButtonState() {
        // 다음 버튼 활성화 조건 확인
        guard let password = confirmPasswordTextField.text, !password.isEmpty, password.isPasswordFormatValid()
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
        confirmPasswordTextField.resignFirstResponder()
        
        // 다음 버튼 활성화 확인 메서드
        updateNextButtonState()
    }
}
