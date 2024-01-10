//
//  StepThreeViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/10/04.
//

import UIKit

class StepThreeViewController: UIViewController {
    
    @IBOutlet weak var countTextLabel: UILabel!
    
    @IBOutlet weak var diaryTextView: UITextView!
    
    let textViewPlaceHolder = "GPT가 자동으로 만들어 드릴게요"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        setupTextVIew()
    }
    
    //MARK: - 레이블 셋업 메서드
    private func setupLabel() {
        countTextLabel.textColor = .blueGray100
        countTextLabel.font = .boldSystemFont(ofSize: 16)
    }
    
    //MARK: - 텍스트 뷰 셋업 메서드
    private func setupTextVIew() {
        
        diaryTextView.font = .boldSystemFont(ofSize: 16)
        diaryTextView.textColor = .blueGray200
        diaryTextView.setCornerRadius(6)
        diaryTextView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
//        diaryTextView.delegate = self
        
        diaryTextView.text = textViewPlaceHolder
    }
}

