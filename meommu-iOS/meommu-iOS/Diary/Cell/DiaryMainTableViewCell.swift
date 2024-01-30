//
//  DiaryMainTableViewCell.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/18.
//

import UIKit
import AlamofireImage
import PanModal

class DiaryMainTableViewCell: UITableViewCell {
    
    static let id = "DiaryMainCell"
    static let cellHeight = 559.0
    
    // cv의 양 끝 간격
    private let cvCellInset: CGFloat = 20
    // cv의 cell들 간격
    private let cvMinimumLineSpacing: CGFloat = 13.0
    
    // 일기 수정 및 삭제 버튼 클로저
    var diaryReviseAction : (() -> ()) = {}
    // 이미지 url 저장 배열
    var imageUrls: [String] = []
    
    @IBOutlet var diaryNameLabel: UILabel!
    @IBOutlet var diaryDateLabel: UILabel!
    @IBOutlet var diaryDetailLabel: UILabel!
    @IBOutlet var diaryTitleLabel: UILabel!
    

    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerXib()
        
        setupCV()
        
    }
    
    
    private func registerXib(){
        imageCollectionView.register(UINib(nibName: DiaryMainTableImageCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DiaryMainTableImageCollectionViewCell.identifier)
    }
    
    private func setupCV(){
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        imageCollectionView.decelerationRate = .fast
        imageCollectionView.isPagingEnabled = false
        
        imageCollectionView.showsHorizontalScrollIndicator = false
        
        imageCollectionView.contentInset = UIEdgeInsets(top: 0, left: cvCellInset, bottom: 0, right: cvCellInset)
        
        // layout 관련 메서드
        imageCollectionView.collectionViewLayout = setupCVLayout()
    }
    
    private func setupCVLayout() -> UICollectionViewFlowLayout {
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        // 각 item의 크기 설정
        collectionViewLayout.itemSize = CGSize(width: DiaryMainTableImageCollectionViewCell.cellWidth, height: DiaryMainTableImageCollectionViewCell.cellHeight)
        
        collectionViewLayout.scrollDirection = .horizontal
        
        collectionViewLayout.minimumLineSpacing = cvMinimumLineSpacing
        collectionViewLayout.minimumInteritemSpacing = 0
        
        return collectionViewLayout
    }
    
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate 확장
extension DiaryMainTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryMainTableImageCollectionViewCell.identifier, for: indexPath) as? DiaryMainTableImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setupImageView(imageURL: imageUrls[indexPath.row])
        
        return cell
    }
    
    // 페이징을 기능
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
            guard let layout = self.imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            
            let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
            
            let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
            let index: Int
            if velocity.x > 0 {
                index = Int(ceil(estimatedIndex))
            } else if velocity.x < 0 {
                index = Int(floor(estimatedIndex))
            } else {
                index = Int(round(estimatedIndex))
            }
            
        // 양쪽 끝에 추가된 여백을 고려하기 위해 cvCellInset만큼 빼기
            targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing - CGFloat(cvCellInset), y: 0)
        }
}





// 셀이 재사용되기 전에 호출되는 메서드
//override func prepareForReuse() {
//    super.prepareForReuse()
//    // 일반적으로 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해서 실행
//    //        self.diaryImageView.image = nil
//}

//MARK: - 이미지 설정 메서드 + 이미지 개수 표
//    func setImageUrls(_ urls: [String]) {
//        if let firstUrl = urls.first, let url = URL(string: firstUrl) {
//            diaryImageView.af.setImage(withURL: url)
//        }
//
//        // 이미지 카운트 ❓
//        if(urls.count > 0){
//            imagePageLabel.text = "1 / \(urls.count)"
//        } else {
//            imagePageLabel.text = "0 / \(urls.count)"
//        }
//    }

//MARK: - 다이어리 수정 버튼 탭 메서드
//    @IBAction func diaryReviseButtonTapped(_ sender: Any) {
//        diaryReviseAction()
//    }
