//
//  DiarySendNameViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/19.
//

import UIKit

class DiarySendNameViewController: UIViewController {
    static let StoryboardName = "DiaryWrite"
    static let identifier = "DiarySendNameViewController"
    static let navigationIdentifier = "DiaryWriteViewController"
    
    // 일기 데이터
    var diary: Diary?
    // 일기 수정 상태 확인
    var isEdited: Bool = false
    
    
    // 뒤로 가기 버튼
    @IBOutlet var backButton: UIBarButtonItem!
    
    // 뷰 설정
    @IBOutlet var profileView: UIView!
    
    // 이미지 설정
    @IBOutlet var profileImageView: UIImageView!
    
    // 강아지 이름 작성 텍스트 필드
    @IBOutlet var nameTextField: UITextField!
    
    // 작성하기 버튼
    @IBOutlet var nextButton: UIButton!
    
    
    //MARK: - viewDidLoad 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCornerRadius()
        setupDelegate()
        setupButton()
        
        setupEditedUI()
        
        
    }
    
    //MARK: - 일기 수정 VC 인스턴스 만드는 메서드
    static func makeDiaryEditedVCInstance(diary: Diary) -> UINavigationController {
        // 수정을 위한 일기 작성 화면 띄우기
        let storyboard = UIStoryboard(name: DiarySendNameViewController.StoryboardName, bundle: nil)
        let naviController = storyboard.instantiateViewController(identifier: DiarySendNameViewController.navigationIdentifier) as! UINavigationController
        
        // 컨트롤러는 참조 타입
        let diaryEditedVC = naviController.viewControllers[0] as! DiarySendNameViewController
        
        diaryEditedVC.isEdited = true
        diaryEditedVC.diary = diary
        
        return naviController
    }
    
    //MARK: - 버튼 셋업 메서드
    private func setupButton() {
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // 수정 상태일 때는 버튼 바로 활성화
        if isEdited { return }
        
        // 작성하기 버튼 초기 상태 비활성화
        nextButton.isEnabled = false
    }
    
    //MARK: - 델리게이트 셋업 메서드
    private func setupDelegate() {
        // nameTextField의 delegate 설정
        nameTextField.delegate = self
    }
    
    //MARK: - 코너레디어스 셋업 메서드
    private func setupCornerRadius() {
        profileImageView.layer.cornerRadius = 60
        profileView.layer.cornerRadius = 8
    }
    
    //MARK: - 일기 수정 중일 때 UI 셋업 메서드
    func setupEditedUI() {
        guard self.isEdited else { return }
        
        // 일기 데이터를 화면에 표시
        self.nameTextField.text = self.diary?.dogName
        
    }
    
    
    //MARK: - 백버튼 탭 메서드
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // 이름이 비어있으면 버튼 비활성화
        nextButton.isEnabled = !(textField.text?.isEmpty ?? true)
    }
    
    //MARK: - prepare 메서드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DiaryWriteViewController {
            guard let vc = segue.destination as? DiaryWriteViewController else { return }
            
            // 수정 시에는 일기 데이터 전달
            if isEdited {
                vc.diary = diary
                vc.isEdited = true
                
                vc.dogName = diary?.dogName
                
                return
            }
            
            // nameTextField의 값 가져오기
            guard let dogName = nameTextField.text else { return }
            
            vc.dogName = dogName
        }
    }
    
}

//MARK: - UITextFieldDelegate 확장
extension DiarySendNameViewController: UITextFieldDelegate {
    
    // UITextFieldDelegate 메서드
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // 변경 후의 텍스트의 길이가 10 이하인지 확인
        return updatedText.count <= 10
    }
    
}

