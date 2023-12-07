//
//  DiaryImageCollectionViewCell.swift
//  meommu-iOS
//
//  Created by 이예빈 on 12/6/23.
//

import UIKit

class DiaryImageCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        diaryImageView.layer.cornerRadius = 4
        
        contentView.layer.cornerRadius = 4
        //contentView.layer.borderWidth = 2
        //contentView.layer.borderColor = UIColor(named: "Gray200")?.cgColor
        //contentView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
        //contentView.isOpaque = false
        
        // 삭제 버튼에 액션 추가
        diaryImageDeleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
    }
    
    // 삭제 버튼 클릭 시 실행될 클로저
    var onDelete: (() -> Void)?
    
    @objc func deleteButtonClicked() {
        onDelete?()
    }
    
    @IBOutlet var diaryImageView: UIImageView!
    
    @IBOutlet var diaryImageDeleteButton: UIButton!
}
