//
//  DiaryMainEmptyTableViewCell.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/18.
//

import UIKit

class DiaryMainEmptyTableViewCell: UITableViewCell {

    @IBOutlet var View: UIView!
    @IBOutlet var meommuImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        View.layer.cornerRadius = 30
        meommuImage.layer.cornerRadius = 30
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
