//
//  StepTwoTableViewCell.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/26.
//

import UIKit

class StepTwoTableViewCell: UITableViewCell {
    
    @IBOutlet var detailLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 셀 사이의 간격을 추기 위해 설정
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        
        // 코너 레디어스 설정
        contentView.setCornerRadius(6)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 셀 선택 시 배경색 변경 없애기
        self.selectionStyle = .none
    }
    
    //MARK: - setSelected 메서드
    // 셀 선택 UI 설정
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            contentView.backgroundColor = UIColor(named: "primaryA")
            detailLabel.textColor = .white
        } else {
            contentView.backgroundColor = UIColor(named: "BlueGray400")
            detailLabel.textColor = UIColor(named: "BlueGray200")
        }
    }
}
