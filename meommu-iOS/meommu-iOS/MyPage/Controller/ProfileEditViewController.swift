//
//  ProfileEditViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/19.
//

import UIKit

class ProfileEditViewController: UIViewController {
    
    // 유저 정보 모델
    var userProfile: UserProfileModel?
    
    // 수정하기 상태 확인을 위한 프로퍼티
    private var editingMode = false

    @IBOutlet weak var profileView: UIView!
    
    // 질문 레이블 프로터피
    @IBOutlet weak var kindergartenNameLabel: UILabel!
    @IBOutlet weak var representativeNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    // 입력 텍스트 필드 프로퍼티
    @IBOutlet weak var kindergartenNameTextField: UITextField!
    @IBOutlet weak var representativeNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    // 상태 확인을 위한 레이블
    @IBOutlet weak var kindergartenNameStatusLabel: UILabel!
    @IBOutlet weak var representativeNameStatusLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var editModeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfile()
        setupLabel()
        setupTextField()
        setupButtons()
        configureUIForDefaultState()
    }
    
    //MARK: - 기본 상태 UI 설정
    func configureUIForDefaultState() {
        editModeButton.isEnabled = true
        // ❗️이후에 컬러 수정
        editModeButton.tintColor = .black
        // 수정하기 버튼 숨기기
        editButton.layer.isHidden = true
        }

    //MARK: - 수정 모드 UI 설정
        func configureUIForEditMode() {
            // 수정 모드 버튼 숨기기
            editModeButton.isEnabled = false
            editModeButton.tintColor = .clear
            
            // 수정하기 버튼 보이기
            editButton.layer.isHidden = false
        }
    
    //MARK: - 프로필 셋업 메서드
    func setupProfile() {
        profileView.setCornerRadius(30)
    }
    
    //MARK: - 텍스트 필드 셋업 메서드
    func setupTextField() {
        // 텍스트 필드 델리게이트 설정
        kindergartenNameTextField.delegate = self
        representativeNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        // 텍스트 필드 기존 데이터 값 할당
        kindergartenNameTextField.text = userProfile?.kindergartenName
        representativeNameTextField.text = userProfile?.representativeName
        phoneNumberTextField.text = userProfile?.phoneNumber
    }
    
    //MARK: - 상태 레이블 셋업 메서드
    func setupLabel() {
        kindergartenNameStatusLabel.text = ""
        representativeNameStatusLabel.text = ""
        
        kindergartenNameStatusLabel.textColor = .red
        representativeNameStatusLabel.textColor = .red
    }
    
    //MARK: - 버튼 셋업 메서드
    func setupButtons(){
        // 다음 버튼 색상
        editButton.backgroundColor = Color.darkGray.buttonColor
        editButton.setTitleColor(Color.white.textColor, for: .normal)
        
        // 다음 버튼 초기 비활성화
        editButton.isEnabled = false
    }
    
    //MARK: - 전화번호 형식 확인 메서드
    func isValidPhoneNumber(_ phoneNumber: String?) -> Bool {
        // 옵셔널 문자열을 언래핑하고 빈 문자열 체크
        guard let phoneNumber = phoneNumber, !phoneNumber.isEmpty else {
            return false
        }
        
        // 전화번호 정규식 패턴
        let phoneNumberPattern = #"^01[016789]-\d{3,4}-\d{4}$"#
        let regex = try! NSRegularExpression(pattern: phoneNumberPattern)
        let range = NSRange(location: 0, length: phoneNumber.utf16.count)
        return regex.firstMatch(in: phoneNumber, options: [], range: range) != nil
    }
    
    //MARK: - 유치원 이름 형식 확인 메서드
    func isValidkindergartenName(_ kindergartenName: String?) -> Bool {
        // 옵셔널 문자열을 언래핑하고 빈 문자열 체크
        guard let kindergartenName = kindergartenName, !kindergartenName.isEmpty else {
            return false
        }
        
        // 글자 수 체크
        if kindergartenName.count < 2 || kindergartenName.count > 13 {
            return false
        } else {
            return true
        }
    }
    
    //MARK: - 유치원 이름 형식 확인 메서드
    func isValidrepresentativeName(_ representativeName: String?) -> Bool {
        // 옵셔널 문자열을 언래핑하고 빈 문자열 체크
        guard let representativeName = representativeName, !representativeName.isEmpty else {
            return false
        }
        
        // 글자 수 체크
        if representativeName.count < 2 || representativeName.count > 8 {
            return false
        } else {
            return true
        }
    }
    
    //MARK: - 수정하기 모드 버튼 탭 메서드
    @IBAction func editModeButtonTapped(_ sender: UIBarButtonItem) {
        configureUIForEditMode()
        editingMode = true
    }
    
    
    
    //MARK: - 수정하기 버튼 탭 메서드
    @IBAction func editButtonTapped(_ sender: UIButton) {
        
        if isValidkindergartenName(kindergartenNameTextField.text) && isValidrepresentativeName(representativeNameTextField.text) {
            
            // ❗️서버와 통신하여 바뀐 데이터 값으로 수정하는 로직 추가
            
            self.navigationController?.popViewController(animated: true)
        } else if !isValidkindergartenName(kindergartenNameTextField.text) && !isValidrepresentativeName(representativeNameTextField.text){
            
            kindergartenNameStatusLabel.text = "사용하실 수 없는 닉네임입니다."
            representativeNameStatusLabel.text = "사용하실 수 없는 대표자 이름입니다."
            
            editButton.backgroundColor = Color.darkGray.buttonColor
            editButton.isEnabled = false
            
        } else if isValidkindergartenName(kindergartenNameTextField.text) {
            
            representativeNameStatusLabel.text = "사용하실 수 없는 대표자 이름입니다."
            
            editButton.backgroundColor = Color.darkGray.buttonColor
            editButton.isEnabled = false
            
        } else if isValidrepresentativeName(representativeNameTextField.text) {
            
            kindergartenNameStatusLabel.text = "사용하실 수 없는 닉네임입니다."
            
            editButton.backgroundColor = Color.darkGray.buttonColor
            editButton.isEnabled = false
            
        }
        print("문제 발생!")
    }
    
    //MARK: - 백 버튼 탭 메서드
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        
        if editingMode {
            // 수정 모드에서 백버튼 상황
            configureUIForDefaultState()
            editingMode = false
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

//MARK: - UITextViewDelegate 확장
extension ProfileEditViewController: UITextFieldDelegate {
    //MARK: - 델리게이트 메서드 - 텍스트 필드 입력을 시작할 지 결정 메서드
    //키보드 올라오면 함수 호출
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            if editingMode {
                // 수정 모드에서 텍스트 필드 수정 가능
                return true
            } else {
                // 일반 모드에서 텍스트 필드 수정 불가능
                return false
            }
        }
    
    //MARK: - 델리게이트 메서드 - 텍스트 필드 입력 시작 시 실행되는 메서드
    // 텍스트 필드 클릭 시 상태 메시지를 지워주기 위함
    func textFieldDidBeginEditing(_ textField: UITextField) {
        kindergartenNameStatusLabel.text = ""
        representativeNameStatusLabel.text = ""
    }

    
    //MARK: - 델리게이트 메서드 - 텍스트 필드 입력 종료 시 실행되는 메서드
    // 키보드 해제되면 텍스트 값이 바꼈는지 확인 후 버튼 활성화
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == kindergartenNameTextField && kindergartenNameTextField.text != userProfile?.kindergartenName {
            editButton.backgroundColor = Color.purple.buttonColor
            editButton.isEnabled = true
            return
        } else if textField == representativeNameTextField && representativeNameTextField.text != userProfile?.representativeName {
            editButton.backgroundColor = Color.purple.buttonColor
            editButton.isEnabled = true
            return
        } else if textField == phoneNumberTextField && phoneNumberTextField.text != userProfile?.phoneNumber && isValidPhoneNumber(phoneNumberTextField.text){
            editButton.backgroundColor = Color.purple.buttonColor
            editButton.isEnabled = true
            return
        }
        editButton.backgroundColor = Color.darkGray.buttonColor
        editButton.isEnabled = false
    }
    
    //MARK: - 델리게이트 메서드 - 텍스트 필드 리턴 시 실행되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 다음 텍스트 필드 활성화 기능
        if textField == kindergartenNameTextField {
            kindergartenNameTextField.resignFirstResponder()
        } else if textField == representativeNameTextField {
            representativeNameTextField.resignFirstResponder()
        } else if textField == phoneNumberTextField {
            phoneNumberTextField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - 화면에 탭을 감지(UIResponder)하는 메서드 - 빈 화면 터치 시 키보드 해지
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        kindergartenNameTextField.resignFirstResponder()
        representativeNameTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
    }
    
    
}
