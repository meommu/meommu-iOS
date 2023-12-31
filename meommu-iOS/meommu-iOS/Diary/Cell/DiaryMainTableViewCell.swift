//
//  DiaryMainTableViewCell.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/18.
//

import UIKit
import AlamofireImage
import PanModal

class DiaryMainTableViewCell: UITableViewCell {

    @IBOutlet var diaryNameLabel: UILabel!
    @IBOutlet var diaryDateLabel: UILabel!
    @IBOutlet var diaryDetailLabel: UILabel!
    @IBOutlet var diaryImageView: UIImageView!
    @IBOutlet var diaryTitleLabel: UILabel!
    
    
    @IBOutlet var imagePageView: UIView!
    @IBOutlet var imagePageLabel: UILabel!
    
    @IBOutlet var diaryReviseButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        diaryImageView.layer.cornerRadius = 6
        
        imagePageView.layer.cornerRadius = 10
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 버튼에 액션 추가
        diaryReviseButton.addTarget(self, action: #selector(diaryReviseButtonTapped), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - 이미지 설정 메서드 + 이미지 개수 표

    func setImageUrls(_ urls: [String]) {
        if let firstUrl = urls.first, let url = URL(string: firstUrl) {
            diaryImageView.af.setImage(withURL: url)
        }
        
        // 이미지 카운트 ❓
        if(urls.count > 0){
            imagePageLabel.text = "1 / \(urls.count)"
        } else {
            imagePageLabel.text = "0 / \(urls.count)"
        }
    }
    
    // 일기 수정 및 삭제 버튼 활성화
    
    var diaryReviseAction : (() -> ()) = {}
    

    //MARK: - 다이어리 수정 버튼 탭 메서드
    @objc func diaryReviseButtonTapped() {
        diaryReviseAction()
    }
}
