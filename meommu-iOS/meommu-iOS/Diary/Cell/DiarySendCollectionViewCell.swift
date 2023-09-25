//
//  DiarySendCollectionViewCell.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/25.
//

import UIKit

class DiarySendCollectionViewCell: UICollectionViewCell {

    @IBOutlet var characterView: UIView!
    @IBOutlet var characterImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        characterView.layer.masksToBounds = true
        characterView.layer.cornerRadius = 50
        
        layer.masksToBounds = false
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.cornerRadius = 50
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
