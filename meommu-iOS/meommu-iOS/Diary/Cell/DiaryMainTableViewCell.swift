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
    
    let height = 330.0
    let cellWidth = 350.0
    
    let sectionSpacing: CGFloat = 20
    let itemSpacing: CGFloat = 8
    
    let colloectionViewLayout = UICollectionViewFlowLayout()
    
    // 일기 수정 및 삭제 버튼 클로저
    var diaryReviseAction : (() -> ()) = {}
    
    @IBOutlet var diaryNameLabel: UILabel!
    @IBOutlet var diaryDateLabel: UILabel!
    @IBOutlet var diaryDetailLabel: UILabel!
    @IBOutlet var diaryTitleLabel: UILabel!
    
    
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerXib()
        registerDelegate()
        
        setupLayout()
        
        
    }
    
    func setupLayout() {
        
        
        // 각 item의 크기 설정 (아래 코드는 정사각형을 그린다는 가정)
        colloectionViewLayout.itemSize = CGSize(width: cellWidth, height: height)
        
        colloectionViewLayout.scrollDirection = .horizontal
        
        colloectionViewLayout.minimumLineSpacing = 8.0
        colloectionViewLayout.minimumInteritemSpacing = 0
        
        imageCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        imageCollectionView.collectionViewLayout = colloectionViewLayout
        imageCollectionView.showsHorizontalScrollIndicator = false
        imageCollectionView.isPagingEnabled = false
        
        
    }
    
    
    private func registerXib(){
        imageCollectionView.register(UINib(nibName: DiaryMainTableImageCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DiaryMainTableImageCollectionViewCell.identifier)
    }
    
    private func registerDelegate(){
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    

    
}

extension DiaryMainTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryMainTableImageCollectionViewCell.identifier, for: indexPath) as? DiaryMainTableImageCollectionViewCell else {
            print("ddddd")
            return UICollectionViewCell()
        }
        cell.imageView.image = UIImage(named: "Onboarding2")
        print("ㅇㅇㅇㅇㅇ  ")
        return cell
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
