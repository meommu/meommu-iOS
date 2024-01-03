//
//  StepOneViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/21.
//

import UIKit
import PanModal


class StepOneViewController: UIViewController {
    
    // cell 관련 프로퍼티
    private let cellName = "StepOneTableViewCell"
    private let cellReuseIdentifire = "StepOneCell"
    
    weak var delegate: BottomSheetControllerDelegate?
    
    // 선택된 데이터를 저장할 배열
    var selectedData: [Int] = [] {
        // didSet을 이용하여 배열이 변경될 때마다 오름차순 정렬
        didSet {
            selectedData.sort()
        }
    }
    
    var guideDataArray: [GPTGuide] = []
    
    // TableView 프로퍼티
    @IBOutlet var stepOneTableVlew: UITableView!
    
    // Title Label 프로퍼티
    @IBOutlet var stepOneMainTitleLabel: UILabel!
    @IBOutlet var stepOneSubTitleLabel: UILabel!
    
    // Page Label 프로퍼티
    @IBOutlet var stepOnePageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
    }
    
    //MARK: - setupTableView 메서드
    private func setupTableView() {
        // 델리게이트, 데이터소스 설정
        stepOneTableVlew.delegate = self
        stepOneTableVlew.dataSource = self
        
        // TabelView에 xib 등록하기.
        let nibName = UINib(nibName: cellName, bundle: nil)
        stepOneTableVlew.register(nibName, forCellReuseIdentifier: cellReuseIdentifire)
        
    }
    
}

//MARK: - TableView 관련 프로토콜 확장
extension StepOneViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guideDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = stepOneTableVlew.dequeueReusableCell(withIdentifier: cellReuseIdentifire, for: indexPath) as! StepOneTableViewCell
        
        cell.detailLabel.text = guideDataArray[indexPath.row].guide
        
        return cell
    }
    
    // cell 선택 시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 선택된 셀의 데이터를 selectedData 배열에 추가
        let selectedCellId = guideDataArray[indexPath.row].id
        if !selectedData.contains(selectedCellId) {
            selectedData.append(selectedCellId)
        }
        
        // 페이지 뷰컨에 인덱스 배열 전달
        delegate?.pageArrayDidChange(data: selectedData)
        
        print(selectedData)
    }
    
    // cell 선택 취소 시
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // 선택 취소된 셀의 데이터를 selectedData 배열에서 제거
        let deselectedCellId = guideDataArray[indexPath.row].id
        if let index = selectedData.firstIndex(of: deselectedCellId) {
            selectedData.remove(at: index)
        }
        
        // 페이지 뷰컨에 인덱스 배열 전달
        delegate?.pageArrayDidChange(data: selectedData)
        
        print(selectedData)
    }
}
