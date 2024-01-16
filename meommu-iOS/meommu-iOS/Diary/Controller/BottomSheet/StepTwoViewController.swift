//
//  StepTwoViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/26.
//

import UIKit
import PanModal


class StepTwoViewController: UIViewController {
    
    // step2에서 선택된 데이터를 저장하기 위한 배열
    var stepTwoGuideDatas: [String] = []
    
    // 해당 뷰컨의 관련된 셀 데이터
    let cellName = "StepTwoTableViewCell"
    let cellReuseIdentifire = "StepTwoCell"
    
    // BottomSheetStepTwoCustomDelegate 프로퍼티
    weak var customVCDeldgate: BottomSheetStepTwoCustomDelegate?
    
    // BottomSheetDataDelegate 프로퍼티
    weak var dataDelegate: BottomSheetDataDelegate?
    
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
    
    //MARK: - View Lifecycle
    // 뷰가 로드된 후 호출되는 메서드
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
    
    //MARK: - Data 저장 메서드
    private func saveSelectedData(_ data: String) {
        stepTwoGuideDatas.append(data)
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
        
        // guideDetailDatas의 detail 데이터를 셀의 레이블에 저장한다.
        cell.detailLabel.text = guideDetailData[indexPath.row].detail
        
        return cell
    }
    
    // 셀이 선택될 때 실행되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 마지막 셀이 선택될 때
        if indexPath.row == guideDetailData.count - 1 {
            // step2-1 vc를 배열에 추가한다.
            showStepTwoCustomVC = true
            customVCDeldgate?.showStepTwoCustomVC(bool: showStepTwoCustomVC)
            
            // 마지막 셀이 아닌 셀이 선택될 떄
        } else {
            dataDelegate?.saveData(guideDetailData[indexPath.row].detail)
        }
    }
    
    // 셀이 선택 해제될 때 실행되는 메서드
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // 마지막 셀이 선택 해제될 때 step2-1 vc를 배열에서 삭제한다.
        if indexPath.row == guideDetailData.count - 1 {
            showStepTwoCustomVC = false
            customVCDeldgate?.showStepTwoCustomVC(bool: showStepTwoCustomVC)
            
            // 마지막 셀이 아닌 셀이 선택될 떄
        } else {
            dataDelegate?.removeData(guideDetailData[indexPath.row].detail)
        }
    }
}



