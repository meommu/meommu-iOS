//
//  DiaryMonthPickerViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 11/30/23.
//

import UIKit
import PanModal

class DiaryMonthPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        MonthPickerCollectionView.delegate = self
        MonthPickerCollectionView.dataSource = self
        MonthPickerCollectionView.register(UINib(nibName: "DiaryMonthPickerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "diaryMonthCell")
    }
    
    
    
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var beforeMonthButton: UIButton!
    @IBOutlet var nextMonthButton: UIButton!
    
    // 이전 버튼을 눌렀을 때
    @IBAction func OnClick_beforeMonthButton(_ sender: Any) {
        selectedYear -= 1
        yearLabel.text = "\(selectedYear)년"
    }
    
    // 다음 버튼을 눌렀을 때
    @IBAction func OnClick_nextMonthButton(_ sender: Any) {
        selectedYear += 1
        yearLabel.text = "\(selectedYear)년"
    }
    
    // CollectionView 설정
    
    var selectedYear = 2023
    var selectedMonth: Int?
    
    @IBOutlet var MonthPickerCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "diaryMonthCell", for: indexPath) as! DiaryMonthPickerCollectionViewCell
        cell.MonthLabel.text = "\(indexPath.row + 1)"
        
        cell.contentView.layer.cornerRadius = 35
        
        return cell
    }
    
    var selectedIndexPath: IndexPath?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 이전에 선택된 셀의 배경색을 원래대로 돌림
        if let selectedIndexPath = selectedIndexPath {
            let cell = collectionView.cellForItem(at: selectedIndexPath) as? DiaryMonthPickerCollectionViewCell
            cell?.contentView.backgroundColor = .white // 원래 색상으로 변경
            cell?.MonthLabel.textColor = UIColor(named: "Gray500")
        }
        
        // 현재 선택된 셀의 배경색을 변경
        let cell = collectionView.cellForItem(at: indexPath) as? DiaryMonthPickerCollectionViewCell
        cell?.contentView.backgroundColor = UIColor(named: "Gray500") // 변경하고 싶은 색상으로 변경
        cell?.MonthLabel.textColor = .white
        
        // 선택된 셀의 인덱스를 저장
        selectedIndexPath = indexPath
        
        //선택된 월 저장
        selectedMonth = indexPath.row + 1
    }
    
    // 확인 버튼
    @IBOutlet var checkButton: UIButton!
    
    @IBAction func OnClick_checkButton(_ sender: Any) {
        guard let month = selectedMonth else { return }
        print("\(selectedYear)년 \(month)월")
    }
    

}

extension DiaryMonthPickerViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(439)  // 바텀 시트의 높이 설정
    }
    
    var cornerRadius: CGFloat {
        return 20.0  // 둥근 모서리 설정
    }
}
