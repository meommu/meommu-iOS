//
//  StepOneTableViewCell.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/24.
//

import UIKit

class StepOneTableViewCell: UITableViewCell {
    
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var emojiLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0))
        
        contentView.layer.cornerRadius = 5
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
