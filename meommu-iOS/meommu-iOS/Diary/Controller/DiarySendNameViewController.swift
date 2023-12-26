//
//  DiarySendNameViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/19.
//

import UIKit

class DiarySendNameViewController: UIViewController {
    
    var diaryData: DiaryIdResponse.Data?
    
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
        
        
        // 일기 수정하기 -> ❗️추후 다른 방식으로 수정
        NotificationCenter.default.addObserver(self, selector: #selector(diaryEdit(_:)), name: NSNotification.Name("diaryEdit"), object: nil)
    }
    
    
    //MARK: - 버튼 셋업 메서드
    private func setupButton() {
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
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
    
    @objc func diaryEdit(_ notification: Notification) {
        guard let diary = notification.userInfo?["diary"] as? DiaryIdResponse.Data else { return }
        
        // 일기 데이터 프로터피에 저장
        self.diaryData = diary
        
        // 일기 데이터를 화면에 표시
        self.nameTextField.text = diary.dogName
        
        // 일기 수정하기 버튼 클릭
        self.isEdited = true
    }
    
    
    
    
    //MARK: - 백버튼 탭 메서드
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        nextButton.isEnabled = !(textField.text?.isEmpty ?? true)
    }
    
    //MARK: - 다음 버튼
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        
            
            // ❗️다음 화면에 일기가 수정 상황이면 데이터 전달
            
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DiaryWriteViewController {
            guard let vc = segue.destination as? DiaryWriteViewController else { return }
            
            // nameTextField의 값 가져오기
            guard let dogName = nameTextField.text else { return }
            
            vc.diaryData = diaryData
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
