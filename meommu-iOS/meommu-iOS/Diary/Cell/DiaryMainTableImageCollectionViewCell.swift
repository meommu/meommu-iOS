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
    
    // 일기 수정 및 삭제 버튼 클로저
    var diaryReviseAction : (() -> ()) = {}
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var diaryReviseButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()

        self.prepare(image: nil)
      }

    func prepare(image: UIImage?) {
        self.imageView.image = image
      }
    
    @IBAction func diaryReviseButtonTapped(_ sender: Any) {
        diaryReviseAction()
    }
    
    func setupImageView(imageURL: String) {
        
        if let imageURL = URL(string: imageURL) {
            imageView.af.setImage(withURL: imageURL)
        }
        imageView.contentMode = .scaleAspectFill
    }

}
