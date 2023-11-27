//
//  LoginFirstViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/09/19.
//

import UIKit

class LoginFirstViewController: UIViewController {
    
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var firstSubTitleLabel: UILabel!
    @IBOutlet weak var secondSubTitleLabel: UILabel!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var recoverPasswordButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    
    
    @IBOutlet weak var loginImageView: UIImageView!
    
    //MARK: - viewDidLoad 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCornerRadius()
        setupTextField()
        setupButton()
        setupView()
        setupLebel()
        setupImageView()
        setupDelegate()
    }
    
    //MARK: - setupCornerRadius 메서드
    func setupCornerRadius() {
        loginButton.setCornerRadius(6.0)
        
    }
    
    //MARK: - setupTextField 메서드
    func setupTextField() {
        emailTextField.backgroundColor = .gray200
        passwordTextField.backgroundColor = .gray200
        
        emailTextField.addLeftPadding()
        passwordTextField.addLeftPadding()
        
        // 비밀 번호 * 표시를 위한 설정
        passwordTextField.textContentType = .oneTimeCode
        
        // 모든 텍스트 필드의 입력 변경 이벤트에 대한 메서드 추가 - 다음 버튼 활성화
        emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
    }
    
    //MARK: - setupButton 메서드
    func setupButton() {
        loginButton.backgroundColor = .gray300
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.isEnabled = false
        
        signupButton.setTitleColor(.gray300, for: .normal)
        recoverPasswordButton.setTitleColor(.gray300, for: .normal)
        
    }
    
    //MARK: - setupView 메서드
    // 비밀번호찾기, 회원가입 사이의 뷰 색상 추가
    func setupView() {
        lineView.backgroundColor = .gray300
    }
    
    //MARK: - setupLebel 메서드
    func setupLebel() {
        mainTitleLabel.textColor = .gray900
        
        firstSubTitleLabel.textColor = .gray900
        secondSubTitleLabel.textColor = .gray900
    }
    
    //MARK: - setupImageView 메서드
    func setupImageView() {
        loginImageView.image = UIImage(named: "Login")
    }
    
    //MARK: - 델리게이트 셋업 메서드
    private func setupDelegate() {
        // 텍스트 필드 delegate 설정
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // UIWindow의 rootViewController를 변경하여 화면전환 함수
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = viewControllerToPresent
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        } else {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    @IBAction func changeWindowButtonToDiary(_ sender: Any) {
        
        let request = LoginRequest(email: emailTextField.text, password: passwordTextField.text)
        
        LoginAPI.shared.login(with: request) { result in
            switch result {
            case .success(let response):
                print("로그인 성공")
                guard let accessToken = response.tokenData?.accessToken else {
                    return
                }
                print(accessToken)
                
                let newStoryboard = UIStoryboard(name: "Diary", bundle: nil)
                let newViewController = newStoryboard.instantiateViewController(identifier: "DiaryViewController")
                self.changeRootViewController(newViewController)
                
            case .failure(let error):
                // 이메일 중복 확인 실패
                print("Error: \(error.message)")
            }
        }
        
    }
    
}

//MARK: - UITextFieldDelegate 확장
extension LoginFirstViewController: UITextFieldDelegate {
    //MARK: - 다음 버튼 활성화 메서드
    private func updateLoginButtonState() {
        // 다음 버튼 활성화 조건 확인
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else {
            loginButton.backgroundColor = .gray300
            loginButton.isEnabled = false
            return
        }
        loginButton.backgroundColor = .prilmaryA
        loginButton.isEnabled = true
    }
    
    //MARK: - 모든 텍스트 피드 입력 동작 시 실행되는 메서드
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        // 첫 텍스트 공백 불가
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        // 다음 버튼 활성화 확인 메서드
        updateLoginButtonState()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // 부드러운 효과를 위해 애니메이션 처리
        UIView.animate(withDuration: 0.3) {
            let transform = CGAffineTransform(translationX: 0, y: -300)
            self.view.transform = transform
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        UIView.animate(withDuration: 0.3) {
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
        }
    }
    
    //MARK: - 델리게이트 메서드 - 텍스트 필드 리턴 시 실행되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 다음 텍스트 필드 활성화 기능
        if textField == emailTextField {
            //            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            
            updateLoginButtonState()
        }
        return true
    }
    
    
    //MARK: - 화면에 탭을 감지(UIResponder)하는 메서드 - 빈 화면 터치 시 키보드 해지
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        
        // 로그인 버튼 활성화 확인 메서드
        updateLoginButtonState()
    }
    
}
