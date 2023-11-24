//
//  StepOneViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/21.
//

import UIKit
import FittedSheets


class StepOneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerXib()
        
        steponeTableVlew.delegate = self
        steponeTableVlew.dataSource = self
        
        
    }
    
    // 2단계 바텀 시트 생성하기
    @IBOutlet var steponeNextButton: UIButton!
    
    @IBAction func OnClick_steponeNextButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "DiaryGuide", bundle: nil)
        
        guard let stepTwoViewController = storyboard.instantiateViewController(withIdentifier: "StepTwoViewController") as? StepTwoViewController else {return}

        
        let sheetController = SheetViewController(controller: stepTwoViewController, sizes: [.fixed(562)])
        sheetController.dismissOnPull = false
        sheetController.dismissOnOverlayTap = true

        
        if let parentSheetController = self.parent as? SheetViewController {
            parentSheetController.dismiss(animated: true){ [weak self] in
                self?.present(sheetController, animated: true, completion: nil)
            }
        }
        
    }

    // -----------------------------------------
    // 1단계 바텀 시트 설정하기

    
    
    // TableView 생성하기
    
    @IBOutlet var steponeTableVlew: UITableView!
    
    var detailData: [String] = ["산책에 관한 일상", "낮잠에 관한 일상", "놀이에 관한 일상", "간식에 관한 일상", "표현(기분)에 관한 일상"]
    var emojiData: [String] = ["🌿", "😴", "⚽", "🍫", "😖"]
    
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
        cell.emojiLabel.text = emojiData[indexPath.section]
        
        // cell 선택 시 배경 컬러 없애기
        cell.selectionStyle = .none
        
        return cell
    }
    
    // cell 선택 시 배경색 변경
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StepOneTableViewCell
        cell.contentView.backgroundColor = UIColor(named: "SelectedButton")
        cell.detailLabel.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StepOneTableViewCell
        cell.contentView.backgroundColor = UIColor(named: "BottomSheetTableView")
        cell.detailLabel.textColor = UIColor(named: "BottomSheetFont")
    }
    
    
}
