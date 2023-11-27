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

        setupCornerRadius()
    }
    
    //MARK: - 코너 레디어스 값 설정 메서드
    private func setupCornerRadius() {
        nextButton.setCornerRadius(6.0)
    
        confirmPasswordTextField.setCornerRadius(4.0)
    }
    //MARK: - 이전 화면 버튼
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}
