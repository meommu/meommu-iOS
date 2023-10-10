//
//  DiarySendViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/18.
//

import UIKit

class DiarySendViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendCollectionView.delegate = self
        sendCollectionView.dataSource = self
        
        registerXib()
    }
    
    // ---------------------------------
    // CollectionViewCell 적용
    @IBOutlet var sendCollectionView: UICollectionView!
    
    // 데이터 불러오기
    let sendList = Character.data
    
    // collectionviewcell xib 파일 등록
    let cellName = "DiarySendCollectionViewCell"
    let cellReuseIdentifire = "DiarySendCell"
    
    private func registerXib() {
        let nibName = UINib(nibName: cellName, bundle: nil)
        sendCollectionView.register(nibName, forCellWithReuseIdentifier: cellReuseIdentifire)
    }
    
    // 데이터의 수에 따라 item 수 정해주기
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sendList.count
    }
    
    // 커스텀한 cell 적용하기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sendCollectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifire, for: indexPath) as! DiarySendCollectionViewCell
        let target = sendList[indexPath.row]
        
        let img = UIImage(named: "\(target.image).png")
        
        cell.characterImage?.image = img
        
        return cell
    }

    
    // 뒤로 가기 버튼
    @IBOutlet var backButton: UIBarButtonItem!
    
    @IBAction func OnClick_backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}
