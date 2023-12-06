//
//  DiaryImageEmptyCollectionViewCell.swift
//  meommu-iOS
//
//  Created by 이예빈 on 12/6/23.
//

import UIKit

class DiaryImageEmptyCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        emptyView.layer.cornerRadius = 4
        emptyView.layer.borderWidth = 2
        emptyView.layer.borderColor = UIColor(named: "Gray200")?.cgColor
        emptyView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
        emptyView.isOpaque = false
    }

    @IBOutlet var emptyView: UIView!
}
