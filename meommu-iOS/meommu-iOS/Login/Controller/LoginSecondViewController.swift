//
//  LoginSecondViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/09/19.
//

import SafariServices
import UIKit


final class LoginSecondViewController: UIViewController {
    
    // 레이블 프로퍼티
    @IBOutlet weak var firstMainLabel: UILabel!
    @IBOutlet weak var secondMainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    @IBOutlet weak var passwordRequirementsLabel: UILabel!
    
    // 이메일 중복 확인을 위한 프로퍼티
    private var isEmailDuplicate = false
    // 비밀번호 확인을 위한 프로퍼티
    private var isPasswordConfirm = false
    // 약관 동의 확인을 위한 프로퍼티
    private var isTermsAndPrivacyButtonAgreed = false
    
    // 이메일, 비밀번호, 비밀번호 확인 텍스트 필드
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    // 약관 동의 체크 버튼
    @IBOutlet weak var termsAndPrivacyButton: UIButton!
    // 이메일 중복 확인 버튼
    @IBOutlet weak var emailDuplicateCheckButton: UIButton!
    // 다음 버튼
    @IBOutlet weak var nextButton: UIButton!
    // 백 버튼
    @IBOutlet weak var backButton: UIButton!
    
    // 상태 확인을 위한 레이블
    @IBOutlet weak var emailStatusLabel: UILabel!
    @IBOutlet weak var passwordStatusLabel: UILabel!
    @IBOutlet weak var confirmPasswordStatusLabel: UILabel!
    
    // 서비스 이용 및 개인정보 텍스트뷰
    @IBOutlet weak var agreedToTermsText: UITextView!
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabels()
        setupTextFields()
        setupTextViews()
        setupButtons()
        
        setupCornerRadius()
        setupDelegate()
        addAttributesToText()
        
    }
    
    //MARK: - 레이블 셋업 메서드
    private func setupLabels() {
        
        firstMainLabel.textColor = .gray900
        secondMainLabel.textColor = .gray900
        subLabel.textColor = .gray400
        
        emailLabel.textColor = .gray800
        passwordLabel.textColor = .gray800
        confirmPasswordLabel.textColor = .gray800
        
        passwordRequirementsLabel.textColor = .gray400
        emailStatusLabel.text = ""
        passwordStatusLabel.text = ""
        confirmPasswordStatusLabel.text = ""
    }
    
    //MARK: - 텍스트뷰 셋업 메서드
    private func setupTextViews(){
        // 약관 관련 텍스트 뷰 세팅
        agreedToTermsText.textColor = .gray700
        agreedToTermsText.isEditable = false
        agreedToTermsText.textContainerInset = .zero
    }
    
    //MARK: - 버튼 셋업 메서드
    private func setupButtons(){
        // 다음 버튼 색상
        nextButton.backgroundColor = .gray300
        nextButton.setTitleColor(.white, for: .normal)
        
        // 백 버튼 색상
        backButton.tintColor = .gray400
        
        // 중복 확인 버튼 색상
        emailDuplicateCheckButton.backgroundColor = .gray200
        emailDuplicateCheckButton.setTitleColor(.gray300, for: .normal)
        
        // 다음 버튼 초기 비활성화
        nextButton.isEnabled = false
        
        termsAndPrivacyButton.tintColor = .gray200
        termsAndPrivacyButton.addTarget(self, action: #selector(buttonToggleAgreement), for: .touchUpInside)
    }
    
    //MARK: - 텍스트 필드 셋업 메서드
    private func setupTextFields() {
        
        // 텍스트 필드 백그라운드 컬러 설정
        emailTextField.backgroundColor = .gray200
        passwordTextField.backgroundColor = .gray200
        confirmPasswordTextField.backgroundColor = .gray200
        
        // 텍스트 필드가 눌리는 이벤트에 대한 메서드 추가 - 설명 레이블 수정
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidBegin(_:)), for: .editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidBegin(_:)), for: .editingDidBegin)
        confirmPasswordTextField.addTarget(self, action: #selector(confirmPasswordTextFieldDidBegin(_:)), for: .editingDidBegin)
        
        // 모든 텍스트 필드의 입력 변경 이벤트에 대한 메서드 추가 - 다음 버튼 활성화
        emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        // 비밀 번호 * 표시를 위한 설정
        passwordTextField.textContentType = .oneTimeCode
        confirmPasswordTextField.textContentType = .oneTimeCode
    }
    
    //MARK: - 델리게이트 셋업 메서드
    private func setupDelegate() {
        // 약관 동의 텍스트 뷰 delegate 설정
        agreedToTermsText.delegate = self
        
        // 텍스트 필드의 delegate 설정
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    //MARK: - 코너 레디어스 값 설정 메서드
    private func setupCornerRadius() {
        emailDuplicateCheckButton.setCornerRadius(4.0)
        nextButton.setCornerRadius(6.0)
        
        emailTextField.setCornerRadius(4.0)
        passwordTextField.setCornerRadius(4.0)
        confirmPasswordTextField.setCornerRadius(4.0)
    }
    
    
    //MARK: - 약관 동의 관련 메서드
    @objc private func buttonToggleAgreement() {
        if isTermsAndPrivacyButtonAgreed {
            // Tint 색 비활성화
            termsAndPrivacyButton.tintColor = .gray200 // 원하는 비활성화된 Tint 색상 설정
        } else {
            // Tint 색 활성화
            termsAndPrivacyButton.tintColor = .gray800 // 원하는 활성화된 Tint 색상 설정
        }
        
        // Tint 색의 상태를 토글
        isTermsAndPrivacyButtonAgreed.toggle()
        
        // 다음 버튼 활성화 확인 메서드
        updateNextButtonState()
    }
    
    //MARK: - 이전 화면 버튼
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    //MARK: - 약관 관련 모든 내용이 담긴 페이지 보여주기 메서드
    @IBAction func presentTermsAndPrivacyPage(_ sender: UIButton) {
        guard let url = URL(string: "https://glittery-indigo-2e2.notion.site/8628c2aec700417299577d4ab1547f3d")   else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    //MARK: - 이메일 중복 확인 상태 업테이트 메서드
    func emailCheckSuccessUIUpdate(label: UILabel, button: UIButton , message: String) {
        label.text = message
        label.textColor = .success
        
        button.setTitleColor(.success, for: .normal)
        button.layer.borderColor = UIColor.success.cgColor
        button.layer.borderWidth = 2
        
    }
    
    func emailCheckFailureUIUpdate(label: UILabel, button: UIButton , message: String) {
        label.text = message
        label.textColor = .red
        
        button.setTitleColor(.red, for: .normal)
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 2

    }

    //MARK: - 이메일 중복 확인 메서드
    @IBAction func checkEmailDuplication(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        
        if !email.isEmailFormatValid() {
            
            let statusMessage = "이메일을 알맞게 입력해주세요."
            emailCheckFailureUIUpdate(label: emailStatusLabel, button: emailDuplicateCheckButton, message: statusMessage)
            
        } else if email.isEmailFormatValid() {
            
            let request = CheckEmailDuplicationRequest(email: email)
            
            SignUpAPI.shared.checkEmailDuplication(with: request) { result in
                switch result {
                case .success(let response):
                    guard let data = response.data else { return }
                    
                    self.isEmailDuplicate = data
                    
                    // 이메일 사용 가능
                    if self.isEmailDuplicate {
                        
                        let statusMessage = "사용 가능한 이메일입니다."
                        self.emailCheckSuccessUIUpdate(label: self.emailStatusLabel, button: self.emailDuplicateCheckButton, message: statusMessage)
                
                    } else {
                        // 이메일 중복으로 사용 불가능
                        let statusMessage = "사용 불가능한 이메일입니다."
                        self.emailCheckFailureUIUpdate(label: self.emailStatusLabel, button: self.emailDuplicateCheckButton, message: statusMessage)
                    }
                    
                case .failure(let error):
                    // 통신 오류
                    print("Error: \(error.message)")
                }
            }
            
        }
        
        emailTextField.resignFirstResponder()
        
        // 다음 버튼 활성화 메서드
        updateNextButtonState()
    }
    
    //MARK: - 다음 버튼 활성화 메서드
    private func updateNextButtonState() {
        // 다음 버튼 활성화 조건 확인
        guard let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty,
              isEmailDuplicate,
              isTermsAndPrivacyButtonAgreed
        else {
            nextButton.backgroundColor = .gray300
            nextButton.isEnabled = false
            return
        }
        nextButton.backgroundColor = .prilmaryA
        nextButton.isEnabled = true
    }
    
    //MARK: - 다음 버튼 탭 메서드
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        // 비밀번호 확인
        isPasswordConfirm = arePasswordEqual()
        
        // 비밀번호, 이메일, 약관 동의 확인 후 다음 페이지 보여주기
        if isPasswordConfirm && isEmailDuplicate && isTermsAndPrivacyButtonAgreed {
            performSegue(withIdentifier: "toLoginThirdVC", sender: self)
        }
    }
    
    // 데이터 전달을 위해 prepare 메서드 재정의
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLoginThirdVC" {
            let loginThirdVC = segue.destination as! LoginThirdViewController
            loginThirdVC.signUpRequest.email = emailTextField.text
            loginThirdVC.signUpRequest.password = passwordTextField.text
            loginThirdVC.signUpRequest.passwordConfirmation = confirmPasswordTextField.text
        }
        
    }
}

//MARK: - UITextViewDelegate 확장
extension LoginSecondViewController: UITextViewDelegate {
    //MARK: - 약관 동의 텍스트 특성 추가 메서드
    private func addAttributesToText() {
        let text = "서비스 이용 및 개인정보 수집약관에 동의합니다."
        let attributedString = NSMutableAttributedString(string: text)
        
        // 특정 키워드 범위 변수
        let termsOfServiceKeywordRange = NSString(string: text).range(of: "서비스 이용")
        let privacyPolicyKeywordRange = NSString(string: text).range(of: "개인정보 수집약관")
        
        // 하이퍼 링크 추가
        // 이용약관
        attributedString.addAttribute(.link,
                                      value: "https://glittery-indigo-2e2.notion.site/8628c2aec700417299577d4ab1547f3d#9ff248ea306a4a6da8de2c3214ebb255",
                                      range: termsOfServiceKeywordRange)
        // 개인정보 처리방침
        attributedString.addAttribute(.link,
                                      value: "https://glittery-indigo-2e2.notion.site/8628c2aec700417299577d4ab1547f3d#d117b28858274d6aacc87700d0fc77f9",
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
    
    //MARK: - UITextView에서 하이퍼링크 클릭 감지 메서드
     func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            let safariViewController = SFSafariViewController(url: URL)
            present(safariViewController, animated: true, completion: nil)
            return false // UITextView의 기본 동작을 중단합니다.
    }
}

//MARK: - UITextFieldDelegate 확장
extension LoginSecondViewController: UITextFieldDelegate {
    //MARK: - 비밀번호 확인 후 레이블 설정 메서드
    // 사용가능한 비밀번호면 true 리턴
    private func arePasswordEqual() -> Bool {
        guard let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else { return false }
        
        if !password.isPasswordFormatValid(){
            passwordStatusLabel.text = "비밀번호를 다시 입력해주세요."
            passwordStatusLabel.textColor = .error
            return false
        } else if password == confirmPassword {
            passwordStatusLabel.text = ""
            return true
        } else {
            confirmPasswordStatusLabel.text = "비밀번호를 다시 입력해주세요."
            confirmPasswordStatusLabel.textColor = .error
            return false
            
        }
    }
    
    //MARK: - 이메일 텍스트 필드 터치 동작 시 실행되는 메서드
    @objc private func emailTextFieldDidBegin(_ textField: UITextField) {
        
        emailStatusLabel.text = ""
        
        // 중복 확인 버튼 기존 형태로 변경
        emailDuplicateCheckButton.backgroundColor = .gray200
        emailDuplicateCheckButton.setTitleColor(.gray300, for: .normal)
        emailDuplicateCheckButton.layer.borderColor = nil
        emailDuplicateCheckButton.layer.borderWidth = 0.0
        
        // 중복확인 결과 취소
        isEmailDuplicate = false
        
        // 다음 버튼 활성화 확인 메서드
        updateNextButtonState()
    }
    
    //MARK: - 비밀번호 텍스트 필드 터치 동작 시 실행되는 메서드
    @objc private func passwordTextFieldDidBegin(_ textField: UITextField) {
        
        passwordStatusLabel.text = ""
        confirmPasswordStatusLabel.text = ""
        
        isPasswordConfirm = false
    }
    
    //MARK: - 비밀번호 확인 텍스트 필드 터치 시 실행되는 메서드
    @objc private func confirmPasswordTextFieldDidBegin(_ textField: UITextField) {
        passwordStatusLabel.text = ""
        confirmPasswordStatusLabel.text = ""
        
        isPasswordConfirm = false
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
        updateNextButtonState()
        
    }
    
    //MARK: - 델리게이트 메서드 - 텍스트 필드 리턴 시 실행되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 다음 텍스트 필드 활성화 기능
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            confirmPasswordTextField.resignFirstResponder()
            // 다음 버튼 활성화 확인 메서드
            updateNextButtonState()
        }
        return true
    }
    
    
    //MARK: - 화면에 탭을 감지(UIResponder)하는 메서드 - 빈 화면 터치 시 키보드 해지
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        
        // 다음 버튼 활성화 확인 메서드
        updateNextButtonState()
    }
}
