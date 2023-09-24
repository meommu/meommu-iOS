//
//  LoginSecondViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/09/19.
//

import UIKit
import SafariServices

class LoginSecondViewController: UIViewController {
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    @IBOutlet weak var termsAndPrivacyButton: UIButton!
    
    
    // 약관 동의 확인을 위한 변수
    var termsAndPrivacyButtonIsAgreed = false
    
    @IBOutlet weak var agreedToTermsText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        agreedToTermsText.delegate = self
        agreedToTermsText.isEditable = false
        agreedToTermsText.textContainerInset = .zero
        
        addAttributesToText()
        
        
    }
    
    
    //MARK: - 초기 세팅 메서드
    
    func configureView() {
        termsAndPrivacyButton.tintColor = .lightGray
        termsAndPrivacyButton.addTarget(self, action: #selector(buttonToggleAgreement), for: .touchUpInside)
    }
    
    //MARK: - 약관 동의 관련 메서드
    
    @objc func buttonToggleAgreement() {
        if termsAndPrivacyButtonIsAgreed {
            // Tint 색 비활성화
            termsAndPrivacyButton.tintColor = .lightGray // 원하는 비활성화된 Tint 색상 설정
        } else {
            // Tint 색 활성화
            termsAndPrivacyButton.tintColor = .black // 원하는 활성화된 Tint 색상 설정
        }
        
        // Tint 색의 상태를 토글
        termsAndPrivacyButtonIsAgreed.toggle()
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
