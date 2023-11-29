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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0))
        
        diaryImageView.layer.cornerRadius = 6
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
    
    func setImageUrls(_ urls: [String]) {
        if let firstUrl = urls.first, let url = URL(string: firstUrl) {
            diaryImageView.af.setImage(withURL: url)
        }
    }
    
    // 일기 수정 및 삭제 버튼 활성화
    
    var diaryReviseAction : (() -> ()) = {}
    
    @IBOutlet var diaryReviseButton: UIButton!

    @objc func diaryReviseButtonTapped() {
        diaryReviseAction()
    }
}
