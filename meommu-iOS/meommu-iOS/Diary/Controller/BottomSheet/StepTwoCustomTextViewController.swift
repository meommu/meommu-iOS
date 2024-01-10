//
//  StepTwoCustomTextViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/12/26.
//

import UIKit

class StepTwoCustomTextViewController: UIViewController {

    
    @IBOutlet weak var countTextLabel: UILabel!
    
    @IBOutlet weak var diaryTextView: UITextView!
    
    let textViewPlaceHolder = "GPT가 자동으로 만들어 드릴게요"
    let tableViewMaxCount = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        setupTextView()
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
extension StepTwoCustomTextViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // 텍스트 뷰가 focus를 얻으면 placeholer, label  지우기
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            
            self.countTextLabel.isHidden = true
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // 텍스트 뷰가 텍스트 없이 focus를 잃으면 placeholer, label 다시 생성
            textView.text = textViewPlaceHolder
            
            self.countTextLabel.isHidden = false
        }
        
        if textView.text.count > tableViewMaxCount {
            //글자수 제한에 걸리면 마지막 글자를 삭제함.
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
