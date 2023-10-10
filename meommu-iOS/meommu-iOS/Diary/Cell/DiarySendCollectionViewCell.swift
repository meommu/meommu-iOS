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
    
    // cell이 선택되었을 때 배경색 변경
    override var isSelected: Bool {
        didSet {
            if isSelected {
                characterView.backgroundColor = .systemGray5
            } else {
                characterView.backgroundColor = .white
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
