//
//  DiaryImageButtonCollectionViewCell.swift
//  meommu-iOS
//
//  Created by 이예빈 on 12/6/23.
//

import UIKit

class DiaryImageButtonCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        diaryImageButtonView.layer.cornerRadius = 4
        diaryImageButtonView.layer.borderWidth = 2
        diaryImageButtonView.layer.borderColor = UIColor(named: "Gray200")?.cgColor
        diaryImageButtonView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
        diaryImageButtonView.isOpaque = false
    }
    
    @IBOutlet var diaryImageButtonView: UIView!
    
    @IBOutlet var diaryImagePickerButton: UIButton!
    
    @IBOutlet var diaryImageCountLabel: UILabel!
}
