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
        emailTextField.setCornerRadius(4.0)
        passwordTextField.setCornerRadius(4.0)
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
    
    
    //MARK: - loginButtonTapped 메서드
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let request = LoginRequest(email: emailTextField.text, password: passwordTextField.text)
        
        LoginAPI.shared.login(with: request) { result in
            switch result {
            case .success(let response):
                self.handleLoginStatusCode(response)
                print(#function)
            case .failure(let error):
                // 400~500 에러
                print("Error: \(error.message)")
            }
        }
    }
    
    // 로그인 상태 코드에 따른 분기처리를 위한 메서드
    func handleLoginStatusCode(_ response: LoginResponse) {
 
        if response.code == "0000" {
            
            guard let data = response.data else { return }
            
            // 엑세스 토큰 키체인 저장
            storeAccessToken(data.accessToken)
            
            // 로그인하고 일기 화면으로 rootView 변경
            let newStoryboard = UIStoryboard(name: "Diary", bundle: nil)
            let newViewController = newStoryboard.instantiateViewController(identifier: "DiaryViewController")
            
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
            sceneDelegate.changeRootViewController(newViewController, animated: true)
        } else {
            // 이후 토스트로 상태 보여주기 (아이디, 비번 틀림)
            
            // 텍스트 필드 비우기
            emailTextField.text = ""
            passwordTextField.text = ""
            
            // 버튼 초기화
            loginButton.backgroundColor = .gray300
            loginButton.isEnabled = false
            
            // 키보드 내리기.
            emailTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            
            ToastManager.showToastBelowTextField(message: "비밀번호를 다시 입력해주세요.", font: .systemFont(ofSize: 16, weight: .medium), belowTextField: passwordTextField, in: self)
            
            print("아디, 비번 틀림")
        }
    }
    
    //MARK: - 액세스 토큰 저장 메서드
    func storeAccessToken(_ acessToken: String) {
        
        let key = KeyChain.shared.accessTokenKey
        KeyChain.shared.create(key: key, token: acessToken)
        
    }
    
}

//MARK: - UITextFieldDelegate 확장
extension LoginFirstViewController: UITextFieldDelegate {
    //MARK: - 다음 버튼 활성화 메서드
    private func updateLoginButtonState() {
        // 다음 버튼 활성화 조건 확인
        guard let email = emailTextField.text, !email.isEmpty, email.isEmailFormatValid(),
              let password = passwordTextField.text, !password.isEmpty
        else {
            loginButton.backgroundColor = .gray300
            loginButton.isEnabled = false
            return
        }
        loginButton.backgroundColor = .primaryA
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
    
    //MARK: - 키보드 활성화 시 화면 올리는 메서드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // 부드러운 효과를 위해 애니메이션 처리
        UIView.animate(withDuration: 0.3) {
            let transform = CGAffineTransform(translationX: 0, y: -300)
            self.view.transform = transform
        }        
    }
    
    //MARK: - 키보드 비활성화 시 화면 내리는 메서드
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
            passwordTextField.becomeFirstResponder()
            updateLoginButtonState()
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
