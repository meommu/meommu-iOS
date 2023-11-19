//
//  AnnouncementTableViewCell.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/11/09.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var buttonImage: UIImageView!
    
    @IBOutlet weak var titleLabelView: UIView!
    @IBOutlet weak var contentLabelView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.prepare(announcment: nil)
    }
    
    func prepare(announcment: Announcment?) {
        titleLabel.text = announcment?.title
        contentLabel.text = announcment?.content
        contentLabelView.isHidden = announcment?.isContentHidden ?? true
        buttonImage.image = contentLabelView.isHidden ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
    }
    
}



