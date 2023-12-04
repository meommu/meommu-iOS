//
//  PasswordRecoveryFourthViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/11/26.
//

import UIKit

class PasswordRecoveryFourthViewController: UIViewController {

    // 버튼 프로퍼티
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
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
        confirmPasswordTextField.backgroundColor = .gray100
        confirmPasswordTextField.addLeftPadding()
        
        // border 설정
        confirmPasswordTextField.layer.borderColor = UIColor.gray300.cgColor
        confirmPasswordTextField.layer.borderWidth = 2.0
        
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
        
        // 1. 이전 화면에서 입력한 비밀번호와 같은 것이 입렫되었는지 확인
        // 2. 비밀번호를 바꾸는 api 메서드 작성
        // 3. 로그인 화면으로 이동
        changeRootViewToLogin()
        
        // 4. 토스트 얼럿 띄우기
    }
    
    // 루트 뷰를 로그인 화면으로 변경하는 메서드
    private func changeRootViewToLogin() {
        // 로그인하고 일기 화면으로 rootView 변경
        let newStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let newViewController = newStoryboard.instantiateViewController(identifier: "LoginFirstViewController")
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        
        sceneDelegate.changeRootViewController(newViewController, animated: true)
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
