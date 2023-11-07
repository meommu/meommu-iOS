//
//  DiaryViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/17.
//

import UIKit

class DiaryViewController: UIViewController {
    
    @IBOutlet var DiaryWriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayMonthSet()
    }

    
    // -----------------------------------------
    // 오늘 날짜 출력하기
    
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    
    func todayMonthSet(){
        //년
        let formatter_year = DateFormatter()
        formatter_year.dateFormat = "yyyy"
        let current_year = formatter_year.string(from: Date())
        
        //월
        let formatter_month = DateFormatter()
        formatter_month.dateFormat = "MM"
        let current_month = formatter_month.string(from: Date())
        
        yearLabel.text = "\(current_year)년"
        monthLabel.text = "\(current_month)월"
    }
    
    // -----------------------------------------
    // 작성하기 버튼 클릭 시 화면 전환

    
    @IBAction func OnClick_DiaryWriteButton(_ sender: Any) {
        let diarysendStoryboard = UIStoryboard(name: "DiarySend", bundle: nil)
        let diarysendVC = diarysendStoryboard.instantiateViewController(identifier: "DiarySendNameViewController")
        diarysendVC.modalPresentationStyle = .fullScreen
        self.present(diarysendVC, animated: true, completion: nil)
        
        //navigationController?.show(diarysendVC, sender: nil)
    }
    
    // -----------------------------------------
    // TableView 기능
        
    @IBOutlet var DiaryMainTableView: UITableView!
        
    // data 불러오기
    let diaryList = Diary.data
        
    // TableViewCell Xib 파일 등록
    let emptycellName = "DiaryMainEmptyTableViewCell"
    let emptycellReuseIdentifire = "DiaryEmptyCell"
        
    let maincellName = "DiaryMainTableViewCell"
    let maincellReuseIdentifire = "DiaryMainCell"
        
    private func registerXibMain() {
        let nibName = UINib(nibName: maincellName, bundle: nil)
        DiaryMainTableView.register(nibName, forCellReuseIdentifier: maincellReuseIdentifire)
    }
       
    private func registerXibEmpty() {
        let nibName = UINib(nibName: emptycellName, bundle: nil)
        DiaryMainTableView.register(nibName, forCellReuseIdentifier: emptycellReuseIdentifire)
    }
}

// -----------------------------------------
// TableView 설정
extension DiaryViewController: UITableViewDelegate, UITableViewDataSource {
    // TableViewCell 행
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // TableViewCell 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        if diaryList.count == 0 {
            return 1
        } else {
            return diaryList.count
        }
    }
    
    // TableViewCell 높이 조절
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if diaryList.count == 0 {
            return 585
        } else {
            return 526
        }
    }
    
    // TableView 출력
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if diaryList.count == 0 {
            
            let diaryCell = DiaryMainTableView.dequeueReusableCell(withIdentifier: emptycellReuseIdentifire, for: indexPath) as! DiaryMainEmptyTableViewCell
            
            return diaryCell
            
        } else {
            
            let diaryCell = DiaryMainTableView.dequeueReusableCell(withIdentifier: maincellReuseIdentifire, for: indexPath) as! DiaryMainTableViewCell
            let target = diaryList[indexPath.section]
            
            diaryCell.diaryImageView?.image = UIImage(named: target.diaryImage[0])
            diaryCell.diaryDateLabel?.text = target.diaryDate
            diaryCell.diaryDetailLabel?.text = target.diaryDetail
            diaryCell.diaryNameLabel?.text = target.diaryName + " 일기"
            diaryCell.diaryTitleLabel?.text = target.diaryTitle
            
            return diaryCell
            
        }
    }
    
    // 정보전달
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDiary = diaryList[indexPath.row]
        
        performSegue(withIdentifier: "showDetail", sender: selectedDiary)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let vc = segue.destination as? DiaryDetailViewController,
               let selectedDiary = sender as? Diary {
                vc.diary = selectedDiary
            }
        }
    }
    
}
