//
//  DiarySendNameViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/19.
//

import UIKit

class DiarySendNameViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = 60
        profileView.layer.cornerRadius = 8
        
        // 작성하기 버튼 초기 상태 비활성화
        writeButton.isEnabled = false
        
        // nameTextField의 delegate 설정
        nameTextField.delegate = self
    }
    
    
    // 이미지 설정
    @IBOutlet var profileImageView: UIImageView!
    // 뷰 설정
    @IBOutlet var profileView: UIView!
    
    // -----------------------------------------
    // 뒤로 가기 버튼
    @IBOutlet var backButton: UIBarButtonItem!
    
    @IBAction func OnClick_BackButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // -----------------------------------------
    // 강아지 이름 작성 텍스트 필드
    @IBOutlet var nameTextField: UITextField! {
        didSet {
            nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        writeButton.isEnabled = !(textField.text?.isEmpty ?? true)
    }
    
    // UITextFieldDelegate 메서드
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // 변경 후의 텍스트의 길이가 10 이하인지 확인
        return updatedText.count <= 10
    }
    
    // -----------------------------------------
    // 작성하기 버튼
    @IBOutlet var writeButton: UIButton!
    
    @IBAction func OnClick_WriteButton(_ sender: Any) {
        
        // nameTextField의 값 가져오기
        guard let dogName = nameTextField.text else { return }
        
        // DiaryWriteViewController에 데이터 전달
        let diarywriteStoryboard = UIStoryboard(name: "DiaryWrite", bundle: nil)
        
        if let navController = diarywriteStoryboard.instantiateViewController(withIdentifier: "DiaryWriteViewController") as? UINavigationController,
           let diarywriteVC = navController.viewControllers.first as? DiaryWriteViewController {
            diarywriteVC.dogName = dogName
            
            navController.modalPresentationStyle = .overFullScreen
            navController.modalTransitionStyle = .crossDissolve
            present(navController, animated: true, completion: nil)
            
        }
    }
}
