//
//  StepTwoViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/26.
//

import UIKit
import PanModal


class StepTwoViewController: UIViewController {
    
    // 해당 뷰컨의 관련된 셀 데이터
    let cellName = "StepTwoTableViewCell"
    let cellReuseIdentifire = "StepTwoCell"
    
    var detailData: [String] = ["산책을 오래 했어요", "산책 중 맛있는 간식을 많이 먹었어요", "산책 중 친한 강아지를 만나 대화 했어요", "걸음을 아주 천천히 걸었어요", "나만의 문장 추가하기"]
    
    @IBOutlet var steptwoTableVlew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerXib()
        
        steptwoTableVlew.delegate = self
        steptwoTableVlew.dataSource = self
        
    }
    
    //MARK: - xib셀 등록 메서드
    private func registerXib() {
        let nibName = UINib(nibName: cellName, bundle: nil)
        steptwoTableVlew.register(nibName, forCellReuseIdentifier: cellReuseIdentifire)
    }
    
}

//MARK: - TableView 확장
extension StepTwoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = steptwoTableVlew.dequeueReusableCell(withIdentifier: cellReuseIdentifire, for: indexPath) as! StepTwoTableViewCell
        cell.detailLabel.text = detailData[indexPath.row]
        
        return cell
    }
    

    
}

