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
    
    // gpt 일기 가이드 정보 저장 프로퍼티 (label 관련)
    var guideData: GPTGuide?
    
    // gpt 일기 디테일 데이터 저장 배열 프로퍼티 (cell 관련)
    var guideDetailData: [GPTDetailGuide] = [GPTDetailGuide(id: 2, detail: "산책 중에 새로운 친구를 만났어요"),GPTDetailGuide(id: 2, detail: "산책 중에 새로운 친구를 만났어요"),GPTDetailGuide(id: 2, detail: "산책 중에 새로운 친구를 만났어요"),GPTDetailGuide(id: 2, detail: "산책 중에 새로운 친구를 만났어요")] {
        didSet {
            guard self.steptwoTableView != nil else { return }
            DispatchQueue.main.async {
                self.steptwoTableView.reloadData()
                print("스텝 투우우우우")
            }
            
        }
    }
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet var steptwoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupLabel()
        
    }
    
    //MARK: - setupTableView 메서드
    private func setupTableView() {
        // 델리게이트, 데이터소스 설정
        steptwoTableView.delegate = self
        steptwoTableView.dataSource = self
        
        // TabelView에 xib 등록하기.
        let nibName = UINib(nibName: cellName, bundle: nil)
        steptwoTableView.register(nibName, forCellReuseIdentifier: cellReuseIdentifire)
        
    }
    
    //MARK: - Label 셋업 메서드
    private func setupLabel() {
        guard let guideData = self.guideData else { return }
        
        self.mainTitleLabel.text = guideData.guide
        self.subTitleLabel.text = guideData.description
        
    }
    
}

//MARK: - TableView 확장
extension StepTwoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guideDetailData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = steptwoTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifire, for: indexPath) as! StepTwoTableViewCell
        
        cell.detailLabel.text = guideDetailData[indexPath.row].detail
        
        return cell
    }
    
    
    
}

