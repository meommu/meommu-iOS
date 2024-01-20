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
    
    // 일기 수정 및 삭제 버튼 클로저
    var diaryReviseAction : (() -> ()) = {}
    
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
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        // 일반적으로 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해서 실행
        self.diaryImageView.image = nil
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
    
    //MARK: - 다이어리 수정 버튼 탭 메서드
    @IBAction func diaryReviseButtonTapped(_ sender: Any) {
        diaryReviseAction()
    }

}
