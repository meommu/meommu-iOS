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
    
    var customVCDeldgate: BottomSheetStepTwoCustomDelegate?
    
    // step2 커스텀 뷰컨을 보여줄지 판단을 위한 프로퍼티
    // 초기에 '나만의 문장 추가'버튼이 눌려있지 않기 때문에 false로 초기화
    var showStepTwoCustomVC = false
    
    // gpt 일기 가이드 정보 저장 프로퍼티 (label 관련)
    var guideData: GPTGuide?
    
    // gpt 일기 디테일 데이터 저장 배열 프로퍼티 (cell 관련)
    var guideDetailData: [GPTDetailGuide] = [] {
        didSet {
            // 서버에서 받지 않는 데이터 따로 추가
            guideDetailData.append(GPTDetailGuide(id: 0, detail: "나만의 문장 추가하기"))
            
        }
    }
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet var steptwoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupLabel()
        
        // 바뀐 데이터를 적용하기 위해 tableView reload
        DispatchQueue.main.async {
            self.steptwoTableView.reloadData()
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == guideDetailData.count - 1 {
            showStepTwoCustomVC = true
            customVCDeldgate?.showStepTwoCustomVC(bool: showStepTwoCustomVC)
        } else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.row == guideDetailData.count - 1 {
            showStepTwoCustomVC = false
            customVCDeldgate?.showStepTwoCustomVC(bool: showStepTwoCustomVC)
        } else {
            return
        }
    }
}
    

