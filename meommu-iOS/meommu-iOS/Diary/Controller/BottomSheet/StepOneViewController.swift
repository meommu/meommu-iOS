//
//  StepOneViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/21.
//

import UIKit
import PanModal


class StepOneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate {
    
    // 단계 이동
    var selectedDataIndex: Int = 0
    
    var stepTwoViewsDict: [String: UIView] = [:]
    var stepThreeView: UIView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerXib()
        
        steponeTableVlew.delegate = self
        steponeTableVlew.dataSource = self
        
        // 처음에는 1단계 view만
        updateViewForStep()
    }
    

    
    @IBOutlet var steponeNextButton: UIButton!
    
    @IBAction func OnClick_steponeNextButton(_ sender: Any) {
        if selectedDataIndex < selectedData.count {
            // 선택된 항목에 따른 detailData를 업데이트
            let selectedText = selectedData[selectedDataIndex]
            detailData = detailDataDict[selectedText] ?? []
            selectedDataIndex += 1
            // 2단계 뷰 생성 및 저장
            let stepTwoView = UIView()
            stepTwoView.backgroundColor = .red
            stepTwoViewsDict[selectedText] = stepTwoView
        } else if step < 3 {
            // 다음 단계로 이동
            step += 1
            // 3단계 뷰 생성
            stepThreeView = UIView()
            stepThreeView?.backgroundColor = .blue
        }
        updateViewForStep()
    }
    
    
    
    // 선택된 데이터를 저장할 배열
    var selectedData: [String] = []
        
    // 선택된 항목의 detailData를 저장할 dictionary
    var detailDataDict: [String: [String]] = [
        "산책에 관한 일상": ["산책을 오래 했어요", "산책 중 맛있는 간식을 많이 먹었어요", "산책 중 친한 강아지를 만나 대화 했어요", "걸음을 아주 아주 천천히 걸었어요", "나만의 문장 추가하기"],
        "낮잠에 관한 일상": ["낮잠을 오래 잤어요", "낮잠 중 맛있는 간식을 많이 먹었어요", "낮잠 중 친한 강아지를 만나 대화 했어요", "선생님의 품에 안겨잤어요", "나만의 문장 추가하기"],
        "놀이에 관한 일상": [],
        "간식에 관한 일상": [],
        "표현(기분)에 관한 일상": []
    ]
    
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var stepTitleLabel: UILabel!
    
    var step: Int = 1
    
    func updateViewForStep() {
        switch step {
        case 1:
            steponeTableVlew.isHidden = false
            // 모든 2단계 뷰를 숨깁니다.
            for view in stepTwoViewsDict.values {
                view.isHidden = true
            }
            stepThreeView?.isHidden = true
            stepLabel.text = "1단계"
            stepTitleLabel.text = "멈무일기 가이드"
            detailData = ["🌿 산책에 관한 일상", "😴 낮잠에 관한 일상", "⚽ 놀이에 관한 일상", "🍫 간식에 관한 일상", "😖 표현(기분)에 관한 일상"]
        case 2:
            steponeTableVlew.isHidden = false
            stepTwoViewsDict[selectedData[0]]?.isHidden = false  // 첫 번째 선택한 항목에 해당하는 2단계 뷰 보여주기
            stepThreeView?.isHidden = true
            stepLabel.text = "2단계"
            stepTitleLabel.text = selectedData[0] // 첫 번째 선택한 항목으로 타이틀 설정
            detailData = detailDataDict[selectedData[0]] ?? [] // 첫 번째 선택한 항목에 따른 detailData로 업데이트
        case 3:
            steponeTableVlew.isHidden = true
            // 모든 2단계 뷰 숨기기
            for view in stepTwoViewsDict.values {
                view.isHidden = true
            }
            stepThreeView?.isHidden = false
            stepLabel.text = "3단계"
            stepTitleLabel.text = "나만의 문장 추가"
            // detailData 업데이트
        default:
            break
        }
        steponeTableVlew.reloadData()
    }

    
    // TableView 생성하기
    @IBOutlet var steponeTableVlew: UITableView!
    
    var detailData: [String] = []
    
    let cellName = "StepOneTableViewCell"
    let cellReuseIdentifire = "StepOneCell"
    
    private func registerXib() {
        let nibName = UINib(nibName: cellName, bundle: nil)
        steponeTableVlew.register(nibName, forCellReuseIdentifier: cellReuseIdentifire)
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
        let cell = steponeTableVlew.dequeueReusableCell(withIdentifier: cellReuseIdentifire, for: indexPath) as! StepOneTableViewCell
        cell.detailLabel.text = detailData[indexPath.section]
        
        // cell 선택 시 배경 컬러 없애기
        cell.selectionStyle = .none
        
        return cell
    }
    
    // cell 선택 시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StepOneTableViewCell
        cell.contentView.backgroundColor = UIColor(named: "primaryA")
        cell.detailLabel.textColor = .white
        
        // 선택된 셀의 데이터를 selectedData 배열에 추가
        let selectedText = detailData[indexPath.section]
        if !selectedData.contains(selectedText) {
            selectedData.append(selectedText)
        }
    }
    
    // cell 선택 취소 시
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StepOneTableViewCell
        cell.contentView.backgroundColor = UIColor(named: "BlueGray400")
        cell.detailLabel.textColor = UIColor(named: "BlueGray200")
        
        // 선택 취소된 셀의 데이터를 selectedData 배열에서 제거
        let deselectedText = detailData[indexPath.section]
        if let index = selectedData.firstIndex(of: deselectedText) {
            selectedData.remove(at: index)
        }
    }
}


