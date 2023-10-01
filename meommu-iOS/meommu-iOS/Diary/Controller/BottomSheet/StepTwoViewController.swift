//
//  StepTwoViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/26.
//

import UIKit
import PanModal

class StepTwoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        registerXib()
        
        steptwoTableVlew.delegate = self
        steptwoTableVlew.dataSource = self
    }
    
    @IBOutlet var steptwoTableVlew: UITableView!
    
    var detailData: [String] = ["산책을 오래 했어요", "산책 중 맛있는 간식을 많이 먹었어요", "산책 중 친한 강아지를 만나 대화 했어요", "걸음을 아주 천천히 걸었어요", "나만의 문장 추가하기"]
    
    let cellName = "StepTwoTableViewCell"
    let cellReuseIdentifire = "StepTwoCell"
    
    private func registerXib() {
        let nibName = UINib(nibName: cellName, bundle: nil)
        steptwoTableVlew.register(nibName, forCellReuseIdentifier: cellReuseIdentifire)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return detailData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = steptwoTableVlew.dequeueReusableCell(withIdentifier: cellReuseIdentifire, for: indexPath) as! StepTwoTableViewCell
        cell.detailLabel.text = detailData[indexPath.section]
        
        return cell
    }
    
    
}

extension StepTwoViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    // 접혔을 때
    var shortFormHeight: PanModalHeight {
        return .contentHeight(562)
    }
    
    // 펼쳐졌을 때
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(250)
    }
    
    // 최상단 스크롤 불가
    var anchorModalToLongForm: Bool {
        return true
    }
    
    // 드래그로 내려도 화면이 사라지지 않음
    var allowsDragToDismiss: Bool {
        return false
    }
    
    // BottomSheet 호출 시 백그라운드 색상 지정
    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.5)
    }
}
