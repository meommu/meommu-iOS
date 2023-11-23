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
    
    //MARK: - UI 셋업 메서드
    func setupUI() {
        pageImageView.tintColor = .lightGray
        pageNameLabel.textColor = .lightGray
    }
    
}
