//
//  DiaryMainTableImageCollectionViewCell.swift
//  meommu-iOS
//
//  Created by zaehorang on 2024/01/29.
//

import UIKit

class DiaryMainTableImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "DiaryMainTableImageCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        self.prepare(image: nil)
//      }
//
//    func prepare(image: UIImage?) {
//        self.imageView.image = image
//      }
}
