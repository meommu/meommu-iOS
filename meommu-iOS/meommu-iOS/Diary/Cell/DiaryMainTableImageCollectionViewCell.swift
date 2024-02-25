//
//  DiaryMainTableImageCollectionViewCell.swift
//  meommu-iOS
//
//  Created by zaehorang on 2024/01/29.
//

import AlamofireImage
import UIKit

class DiaryMainTableImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "DiaryMainTableImageCollectionViewCell"
    
    static let cellHeight = 329.0
    static let cellWidth = 350.0
    
    
    @IBOutlet weak var imageCountLabel: UILabel!
    
    // 일기 수정 및 삭제 버튼 클로저
    var diaryReviseAction : (() -> ()) = {}
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var diaryReviseButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    @IBAction func diaryReviseButtonTapped(_ sender: Any) {
        diaryReviseAction()
    }
    
    
    private func setupImageView(imageURL: String) {
        if let imageURL = URL(string: imageURL) {
            imageView.af.setImage(withURL: imageURL)
        }
        imageView.contentMode = .scaleAspectFill
        
    }
    
    private func setupCountLabel(count: Int, total: Int) {
        self.imageCountLabel.text = "\(count)/\(total)"
    }
    
    // 셀 셋업
    func setupCell(imageURL: String, count: Int, total: Int) {
        setupImageView(imageURL: imageURL)
        setupCountLabel(count: count, total: total)
    }
    
    
}
