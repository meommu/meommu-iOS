//
//  StepOneViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/21.
//

import UIKit
import PanModal


class StepOneViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    // cell 관련 프로퍼티
    private let cellName = "StepOneTableViewCell"
    private let cellReuseIdentifire = "StepOneCell"
    
    // 선택된 데이터를 저장할 배열
    var selectedData: [String] = []
    
    var guideData: [GPTGuide] = []
    
    
    // TableView 프로퍼티
    @IBOutlet var stepOneTableVlew: UITableView!
    
    // Title Label 프로퍼티
    @IBOutlet var stepOneMainTitleLabel: UILabel!
    @IBOutlet var stepOneSubTitleLabel: UILabel!
    
    // Page Label 프로퍼티
    @IBOutlet var stepOnePageLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDiaryGPTDiaryGudie()
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
    
    private func fetchDiaryGPTDiaryGudie() {
        GPTDiaryAPI.shared.getGPTDiaryGuide { result in
            switch result {
            case .success(let response):
                
                // 받아온 데이터에서 guide를 배열에 할당 후 테이블 리로드한다.
                for data in response.data.guides {
                    self.guideData.append(data)
                }
                DispatchQueue.main.async {
                    self.stepOneTableVlew.reloadData()
                }

            case .failure(let error):
                // 400~500 에러
                print("Error: \(error.message)")
            }
        }
    }
    
}

//MARK: - TableView 관련 프로토콜 확장
extension StepOneViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guideData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = stepOneTableVlew.dequeueReusableCell(withIdentifier: cellReuseIdentifire, for: indexPath) as! StepOneTableViewCell
        
        cell.detailLabel.text = guideData[indexPath.row].guide
        
        // cell 선택 시 배경 컬러 없애기
        cell.selectionStyle = .none
        
        return cell
    }
    
    // cell 선택 시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 선택된 셀의 데이터를 selectedData 배열에 추가
        let selectedText = guideData[indexPath.row].guide
        if !selectedData.contains(selectedText) {
            selectedData.append(selectedText)
        }
        print(selectedData)
    }
    
    // cell 선택 취소 시
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // 선택 취소된 셀의 데이터를 selectedData 배열에서 제거
        let deselectedText = guideData[indexPath.row].guide
        if let index = selectedData.firstIndex(of: deselectedText) {
            selectedData.remove(at: index)
        }
        print(selectedData)
    }
}
