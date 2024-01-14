//
//  StepThreeViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/10/04.
//

import UIKit

class StepThreeViewController: UIViewController {
    
    // BottomSheetDataDelegate 프로퍼티
    weak var dataDelegate: BottomSheetDataDelegate?
    
    let textViewPlaceHolder = "GPT가 자동으로 만들어 드릴게요"
    let tableViewMaxCount = 150
    
    // 텍스트 뷰의 텍스트 여부를 확인하는 프로퍼티
    // 초기에는 placeholer만 있어 false로 초기화한다.
    var hasText = false
    
    @IBOutlet weak var countTextLabel: UILabel!
    @IBOutlet weak var diaryTextView: UITextView!
    
    //MARK: - View Lifecycle
    // 뷰가 로드된 후 호출되는 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        setupTextView()
    }

      // 뷰가 나타날 때 호출되는 메서드
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
          // 사용자가 입력한 텍스트가 저장되어 있다면
          if let text = diaryTextView.text, hasText {
              // 뷰가 재등장 할 때 데이터가 중복해서 저장되는 것을 막기 위해 기존 데이터를 배열에서 먼저 삭제한다.
              dataDelegate?.removeData(text)
          }
      }
    
    // 뷰가 사라질 때 호출되는 메서드
      override func viewDidDisappear(_ animated: Bool) {
          super.viewDidDisappear(animated)

          // 사용자가 입력한 텍스트가 저장되어 있다면
          if let text = diaryTextView.text, hasText {
              // 데이터 중복을 막기 위해 뷰가 사라질 때, 데이터를 저장한다.
              dataDelegate?.saveData(text)
          }
          
      }
    
    // 화면에 탭을 감지(UIResponder)하는 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        diaryTextView.resignFirstResponder()
    }
    
    
    //MARK: - 레이블 셋업 메서드
    private func setupLabel() {
        countTextLabel.textColor = .blueGray100
        countTextLabel.font = .boldSystemFont(ofSize: 16)
    }
    
    //MARK: - 텍스트 뷰 셋업 메서드
    private func setupTextView() {
        
        diaryTextView.font = .boldSystemFont(ofSize: 16)
        diaryTextView.textColor = .blueGray200
        diaryTextView.setCornerRadius(6)
        diaryTextView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        diaryTextView.delegate = self
        
        diaryTextView.text = textViewPlaceHolder
    }
    
}

//MARK: - UITextViewDelegate 확장
extension StepThreeViewController: UITextViewDelegate {
    
    // 텍스트 뷰가 활성화되면 실행되는 메서드
    func textViewDidBeginEditing(_ textView: UITextView) {
        // placehoder가 보이는 텍스트 뷰가 focus를 얻으면 placeholer, label  지우기
        if textView.text == textViewPlaceHolder {
            // placeholer를 지운다.
            textView.text = nil
            
            // 글자 수 제한을 알려주는 레이블을 숨긴다.
            self.countTextLabel.isHidden = true
            
            // 사용자가 글을 입력을 시작해 true를 저장한다.
            self.hasText = true
        }
    }
    
    // 텍스트 뷰가 비활성화되면 실행되는 메서드
    func textViewDidEndEditing(_ textView: UITextView) {
        // 텍스트 뷰가 텍스트 없이 focus를 잃으면
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            
            // placeholer, label 다시 생성한다.
            textView.text = textViewPlaceHolder
            
            // 글자 수 제한을 알려주는 레이블을 보여준다.
            self.countTextLabel.isHidden = false
            
            // 사용자가 글을 입력하지 않아 false를 저장한다.
            self.hasText = false
        }
        
        //글자수 제한에 걸리면
        if textView.text.count > tableViewMaxCount {
            // 마지막 글자를 삭제한다.
            textView.text.removeLast()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //이전 글자 - 선택된 글자 + 새로운 글자(대체될 글자)
        let newLength = textView.text.count - range.length + text.count
        let koreanMaxCount = tableViewMaxCount + 1
        //글자수가 초과 된 경우 or 초과되지 않은 경우
        if newLength > koreanMaxCount { //151글자
            let overflow = newLength - koreanMaxCount //초과된 글자수
            if text.count < overflow {
                return true
            }
            let index = text.index(text.endIndex, offsetBy: -overflow)
            let newText = text[..<index]
            guard let startPosition = textView.position(from: textView.beginningOfDocument, offset: range.location) else { return false }
            guard let endPosition = textView.position(from: textView.beginningOfDocument, offset: NSMaxRange(range)) else { return false }
            guard let textRange = textView.textRange(from: startPosition, to: endPosition) else { return false }
            
            textView.replace(textRange, withText: String(newText))
            
            return false
        }
        return true
    }
}
