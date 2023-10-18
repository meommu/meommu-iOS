//
//  PageCell.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/17.
//

import UIKit

class PageCell: UITableViewCell {
    
    @IBOutlet weak var pageNameLabel: UILabel!
    @IBOutlet weak var pageImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
