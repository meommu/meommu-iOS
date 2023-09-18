//
//  DiaryViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/17.
//

import UIKit

class DiaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // TableViewCell 행
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // TableViewCell 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        if diaryList.isEmpty == true{
            return 1
        } else {
            return diaryList.count
        }
    }
    
    // TableViewCell 높이 조절
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if diaryList.isEmpty == true{
            return 585
        } else {
            return 483
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if diaryList.isEmpty == true {
            
            let diaryCell = DiaryMainTableView.dequeueReusableCell(withIdentifier: emptycellReuseIdentifire, for: indexPath) as! DiaryMainEmptyTableViewCell
            
            return diaryCell
            
        } else {
            
            let diaryCell = DiaryMainTableView.dequeueReusableCell(withIdentifier: maincellReuseIdentifire, for: indexPath) as! DiaryMainTableViewCell
            let target = diaryList[indexPath.section]
            
            diaryCell.diaryImageView?.image = UIImage(named: target.diaryImage)
            diaryCell.diaryDateLabel?.text = target.diaryDate
            diaryCell.diaryDetailLabel?.text = target.diaryDetail
            diaryCell.diaryNameLabel?.text = target.diaryName
            diaryCell.diaryTitleLabel?.text = target.diaryTitle
            
            return diaryCell
            
        }
    }
    

    @IBOutlet var DiaryWriteButton: UIButton!
    
    @IBOutlet var DiaryMainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerXibMain()
        registerXibEmpty()
        
        DiaryMainTableView.delegate = self
        DiaryMainTableView.dataSource = self
    }
    
    
    
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
