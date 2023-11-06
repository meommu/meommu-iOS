//
//  StepThreeViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/10/04.
//

import UIKit
import PanModal

class StepThreeViewController: UIViewController, PanModalPresentable {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DiaryTextFieldSetting()
    }
    
    
    // -----------------------------------------
    // 3단계 바텀 시트 설정하기

    var panScrollable: UIScrollView? {
        return nil
    }
    
    // 접혔을 때
    var shortFormHeight: PanModalHeight {
        return .contentHeight(522)
    }

    // 펼쳤을 때
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(290)
    }

    var cornerRadius: CGFloat {
        return 20
    }

    var allowsTapToDismiss: Bool {
        return true
    }

    var allowsDragToDismiss: Bool {
        return true
    }

    // 최상단 스크롤 불가
    var anchorModalToLongForm: Bool {
        return true
    }
    
    // 텍스트필드 설정
    @IBOutlet var DiaryTextField: UITextField!
    
    func DiaryTextFieldSetting() {
        // 텍스트필드 내부 패딩
        DiaryTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        DiaryTextField.leftViewMode = .always
        
        DiaryTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        DiaryTextField.rightViewMode = .always
        
        // 텍스트필드 테두리 스타일
        DiaryTextField.borderStyle = .roundedRect
        
        // 맞춤법 검사 활성화
        DiaryTextField.spellCheckingType = .no
        
        // 자동 대문자 활성화
        DiaryTextField.autocapitalizationType = .none
        
        // 플레이스 홀더
        DiaryTextField.placeholder = "GPT가 자동으로 만들어 드릴게요            (0/150)"
        
        // 입력 내용 한 번에 지우기 활성화
        DiaryTextField.clearButtonMode = .always
        
        // 편집 시 기존 텍스트필드 값 제거
        DiaryTextField.clearsOnBeginEditing = false
        
        // 키보드 엔터키
        DiaryTextField.returnKeyType = .done
        
        
    }
    
    
}
