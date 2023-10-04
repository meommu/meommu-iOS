//
//  StepThreeViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/10/04.
//

import UIKit
import PanModal

class StepThreeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DiaryTextFieldSetting()
    }
    
    // 텍스트필드 설정
    @IBOutlet var DiaryTextField: UITextField!
    
    func DiaryTextFieldSetting() {
        // 텍스트필드 내부 마진
        DiaryTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        DiaryTextField.leftViewMode = .always
        
        // 텍스트필드 테두리 스타일
        DiaryTextField.borderStyle = .roundedRect
        
        // 맞춤법 검사 활성화
        DiaryTextField.spellCheckingType = .no
        
        // 자동 대문자 활성화
        DiaryTextField.autocapitalizationType = .none
        
        // 플레이스 홀더
        DiaryTextField.placeholder = "GPT가 자동으로 만들어 드릴게요              (0/150)"
        
        // 입력 내용 한 번에 지우기 활성화
        DiaryTextField.clearButtonMode = .always
        
        // 편집 시 기존 텍스트필드 값 제거
        DiaryTextField.clearsOnBeginEditing = false
        
        // 키보드 엔터키
        DiaryTextField.returnKeyType = .done
        
        
    }
    
    
}

extension StepThreeViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    //접혔을 때
    var shortFormHeight: PanModalHeight {
        
        return .contentHeight(562)
    }
    
    //펼쳐졌을 때
    var longFormHeight: PanModalHeight {
        //위에서부터 떨어지게 설정
        return .maxHeightWithTopInset(250)
    }
    
    // 최상단 스크롤 불가
    var anchorModalToLongForm: Bool {
        return true
    }
    
    // 드래그로 내려도 화면이 사라지지 않음
    var allowsDragToDismiss: Bool {
        return false
    }
    
    // BottomSheet 호출 시 백그라운드 색상 지정
    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }
}
