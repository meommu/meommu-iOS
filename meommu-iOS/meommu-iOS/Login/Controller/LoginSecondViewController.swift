//
//  LoginSecondViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/09/19.
//

import UIKit
import SafariServices

class LoginSecondViewController: UIViewController {
    
    // 이메일 중복 확인을 위한 변수
    private var isEmailDuplicate = false
    
    // 비밀번호 확인을 위함 변수
    private var isPasswordConfirm = false
    
    // 약관 동의 확인을 위한 변수
    private var IsTermsAndPrivacyButtonAgreed = false
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var termsAndPrivacyButton: UIButton!
    
    @IBOutlet weak var emailStatusLabel: UILabel!
    @IBOutlet weak var emailDuplicateCheckButton: UIButton!
    
    @IBOutlet weak var passwordStatusLabel: UILabel!
    @IBOutlet weak var confirmPasswordStatusLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var agreedToTermsText: UITextView!
    
    //MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setCornerRadius()
        setupDelegate()
        addAttributesToText()
        
    }
    
    
    //MARK: - 초기 세팅 메서드
    
    func configureView() {
        
        emailStatusLabel.text = ""
        passwordStatusLabel.text = ""
        
        nextButton.isEnabled = false
        
        // 약관 관련 텍스트 뷰 세팅
        agreedToTermsText.isEditable = false
        agreedToTermsText.textContainerInset = .zero
        
        termsAndPrivacyButton.tintColor = .lightGray
        termsAndPrivacyButton.addTarget(self, action: #selector(buttonToggleAgreement), for: .touchUpInside)
        
        
        // 이메일, 비밀 번호, 비밀번호 확인 텍스트 필드의 입력 변경 이벤트에 대한 메서드 추가 - 설명 레이블 수정
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidBegin(_:)), for: .editingDidBegin)
        /*
         passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
         confirmPasswordTextField.addTarget(self, action: #selector(confirmPasswordTextFieldDidChange(_:)), for: .editingChanged)
         */
        
        // 모든 텍스트 필드의 입력 변경 이벤트에 대한 메서드 추가 - 다음 버튼 활성화
        emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    //MARK: - 델리게이트 설정 메서드
    
    func setupDelegate() {
        
        // 약관 동의 텍스트 뷰 delegate 설정
        agreedToTermsText.delegate = self
        
        // 텍스트 필드의 delegate 설정
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    //MARK: - 코너 레디어스 값 설정 메서드
    
    func setCornerRadius() {
        
        emailDuplicateCheckButton.setCornerRadius(4.0)
        nextButton.setCornerRadius(6.0)
        
        emailTextField.setCornerRadius(4.0)
        passwordTextField.setCornerRadius(4.0)
        confirmPasswordTextField.setCornerRadius(4.0)
        
    }
    
    
    //MARK: - 약관 동의 관련 메서드
    
    @objc func buttonToggleAgreement() {
        if IsTermsAndPrivacyButtonAgreed {
            // Tint 색 비활성화
            termsAndPrivacyButton.tintColor = .lightGray // 원하는 비활성화된 Tint 색상 설정
        } else {
            // Tint 색 활성화
            termsAndPrivacyButton.tintColor = .black // 원하는 활성화된 Tint 색상 설정
        }
        
        // Tint 색의 상태를 토글
        IsTermsAndPrivacyButtonAgreed.toggle()
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    //MARK: - 약관 관련 모든 내용이 담긴 페이지 보여주는 메서드
    
    @IBAction func presentTermsAndPrivacyPage(_ sender: UIButton) {
        
        guard let url = URL(string: "https://www.naver.com")   else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    //MARK: - 이메일 중복 확인 메서드
    
    @IBAction func checkEmailDuplication(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        
        
        // 서버 통신 관련 코드는 나중에 작성(이메일 중복 메서드 실행)
        // 이메일 사용이 가능하면 isEmailDuplicate에 true 리턴
        isEmailDuplicate = true
        
        if !isValidEmail(email) {
            emailStatusLabel.text = "이메일을 알맞게 입력해주세요."
            emailStatusLabel.textColor = .red
            
            emailDuplicateCheckButton.setTitleColor(.red, for: .normal)
            emailDuplicateCheckButton.layer.borderColor = UIColor.red.cgColor
            emailDuplicateCheckButton.layer.borderWidth = 2
            
        } else if isEmailDuplicate {
            // 이메일 사용 가능
            emailStatusLabel.text = "사용 가능한 이메일입니다."
            emailStatusLabel.textColor = .green
            
            emailDuplicateCheckButton.setTitleColor(.green, for: .normal)
            emailDuplicateCheckButton.layer.borderColor = UIColor.green.cgColor
            emailDuplicateCheckButton.layer.borderWidth = 2
            
            // 회원 정보 모델에 중복 확인 했다는 것을 넘겨주는 기능이 필요할 듯 -> 확인 후 버튼 활성화
            // 비밀번호도 마찬가지
            
            
        } else {
            // 이메일 사용 불가능
            emailStatusLabel.text = "사용 불가능한 이메일입니다."
            emailStatusLabel.textColor = .red
            
            emailDuplicateCheckButton.setTitleColor(.red, for: .normal)
            emailDuplicateCheckButton.layer.borderColor = UIColor.red.cgColor
            emailDuplicateCheckButton.layer.borderWidth = 2
            
        }
        
        emailTextField.resignFirstResponder()
    }
}

//MARK: - UITextViewDelegate 확장

extension LoginSecondViewController: UITextViewDelegate {
    
    // 약관 동의 텍스트 특성 추가 메서드
    func addAttributesToText() {
        
        let text = "서비스 이용 및 개인정보 수집약관에 동의합니다."
        let attributedString = NSMutableAttributedString(string: text)
        
        // 특정 키워드 범위 변수
        let termsOfServiceKeywordRange = NSString(string: text).range(of: "서비스 이용")
        let privacyPolicyKeywordRange = NSString(string: text).range(of: "개인정보 수집약관")
        
        // 하이퍼 링크 추가
        attributedString.addAttribute(.link,
                                      value: "https://www.google.com/",
                                      range: termsOfServiceKeywordRange)
        
        attributedString.addAttribute(.link,
                                      value: "https://www.apple.com/",
                                      range: privacyPolicyKeywordRange)
        
        // 밑줄 추가
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: termsOfServiceKeywordRange)
        
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: privacyPolicyKeywordRange)
        
        
        agreedToTermsText.attributedText = attributedString
    }
    
    // UITextView에서 하이퍼링크 클릭을 감지하는 메서드
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "https" {
            // https 스킴을 가진 URL을 클릭한 경우 Safari로 엽니다.
            let safariViewController = SFSafariViewController(url: URL)
            present(safariViewController, animated: true, completion: nil)
            return false // UITextView의 기본 동작을 중단합니다.
        }
        return true // 다른 URL 스킴은 기본 동작을 유지합니다.
    }
}

//MARK: - UITextFieldDelegate 확장

extension LoginSecondViewController: UITextFieldDelegate {
    
    // 이메일 형식 확인 메서드
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // 비밀번호 형식 확인 메서드
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9!@#$%^~*+=-])[A-Za-z0-9!@#$%^~*+=-]{8,20}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    
    // 이메일 텍스트 필드의 입력이 변경될 때 호출되는 메서드
    // 중복 확인 후 수정이 진행되면 중복확인 false 교체
    
    @objc func emailTextFieldDidBegin(_ textField: UITextField) {
        
        textField.text = ""
        emailStatusLabel.text = ""
        
        emailDuplicateCheckButton.setTitleColor(.lightGray, for: .normal)
        emailDuplicateCheckButton.layer.borderColor = nil
        emailDuplicateCheckButton.layer.borderWidth = 0.0
        
        isEmailDuplicate = false
    }
    /*
     // 비밀번호 텍스트 필드의 입력이 변경될 때 호출되는 메서드
     @objc func passwordTextFieldDidChange(_ textField: UITextField) {
     if let password = textField.text {
     if !isValidPassword(password) {
     passwordStatusLabel.text = "비밀번호를 다시 입력해주세요."
     passwordStatusLabel.textColor = .red
     isPasswordConfirm = false
     } else if isValidEmail(password) && password != confirmPasswordTextField.text {
     guard let confrimPassword = confirmPasswordTextField.text else {
     passwordStatusLabel.text = ""
     passwordStatusLabel.textColor = .red
     isPasswordConfirm = false
     return
     }
     passwordStatusLabel.text = "비밀번호가 동일하지 않습니다."
     passwordStatusLabel.textColor = .red
     isPasswordConfirm = false
     } else {
     passwordStatusLabel.text = "비밀번호가 동일합니다."
     passwordStatusLabel.textColor = .green
     isPasswordConfirm = true
     }
     }
     }
     
     // 비밀번호 확인 텍스트 필드의 입력이 변경될 때 호출되는 메서드
     @objc func confirmPasswordTextFieldDidChange(_ textField: UITextField) {
     if let confirmPassword = textField.text {
     if isValidPassword(confirmPassword) && passwordTextField.text == confirmPassword {
     passwordStatusLabel.text = "비밀번호가 동일합니다."
     passwordStatusLabel.textColor = .green
     isPasswordConfirm = true
     } else if let password = passwordTextField.text, password != confirmPassword && isValidPassword(password) {
     passwordStatusLabel.text = "비밀번호가 동일하지 않습니다."
     passwordStatusLabel.textColor = .red
     isPasswordConfirm = false
     }
     }
     }
     
     */
    
    // 모든 텍스트 필드 입력 시 버튼 활성화 메서드
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if emailTextField.text?.count == 1 {
            if emailTextField.text?.first == " " {
                emailTextField.text = ""
                return
            }
        }
        guard
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty
        else {
            nextButton.backgroundColor = .lightGray
            nextButton.isEnabled = false
            return
        }
        
        // 이메일 중복 확인, 비밀번호 중복 확인 로직도 필요
        // 회원 정보 모델에 추가된 값으로 확인하고 데이터를 다음 하면에 넘겨줘야 한다.
        
        nextButton.backgroundColor = .black
        nextButton.isEnabled = true
    }
    
    // 델리게이트 메서드 - 텍스트 필드 리턴 시 다음 텍스트 필드 활성화
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            confirmPasswordTextField.resignFirstResponder()
        }
        return true
    }
    
    
    // 화면에 탭을 감지(UIResponder)하는 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
}
