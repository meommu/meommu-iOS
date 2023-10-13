//
//  StepTwoViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/26.
//

import UIKit
import FittedSheets

class StepTwoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        registerXib()
        
        steptwoTableVlew.delegate = self
        steptwoTableVlew.dataSource = self
    }

    
    // TableView 설정
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
        
        // cell 선택 시 배경 컬러 없애기
        cell.selectionStyle = .none
        
        return cell
    }
    
    // cell 선택 시 배경색 변경
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StepTwoTableViewCell
        cell.contentView.backgroundColor = UIColor(named: "SelectedButton")
        cell.detailLabel.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StepTwoTableViewCell
        cell.contentView.backgroundColor = UIColor(named: "BottomSheetTableView")
        cell.detailLabel.textColor = UIColor(named: "BottomSheetFont")
    }
    
}
