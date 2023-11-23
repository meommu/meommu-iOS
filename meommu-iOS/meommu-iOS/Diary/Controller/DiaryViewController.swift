//
//  DiaryViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/17.
//

import UIKit
import Alamofire

class DiaryViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerXibMain()
        registerXibEmpty()
        
        DiaryMainTableView.delegate = self
        DiaryMainTableView.dataSource = self
        
        todayMonthSet()
        fetchData()
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

    @IBOutlet var DiaryWriteButton: UIButton!
    
    @IBAction func OnClick_DiaryWriteButton(_ sender: Any) {
        let diarysendStoryboard = UIStoryboard(name: "DiarySend", bundle: nil)
        let diarysendVC = diarysendStoryboard.instantiateViewController(identifier: "DiarySendNameViewController")
        diarysendVC.modalPresentationStyle = .fullScreen
        self.present(diarysendVC, animated: true, completion: nil)
        
        //navigationController?.show(diarysendVC, sender: nil)
    }
    
    // -----------------------------------------
    // TableView를 통해 전체 일기 조회하기
    
    var diaries: [Diary] = []
    
    @IBOutlet var DiaryMainTableView: UITableView!
        
    let AccessToken = "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6MjcsImlhdCI6MTcwMDYxMzk1OSwiZXhwIjoxNzAxMjE4NzU5fQ.AlQlq-YsMavw3QXJGUEx1FdV-CYdw2YUvhKqohb8JBFztmpl2gjtLPTujXPXEIRMC4MZV901xwVZNT6BbTuNcQ"
    
    private func fetchData() {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AccessToken)",
            "Host": "port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app"
        ]
        
        let parameters: Parameters = [
            "year": "2023",
            "month": "11"
        ]
        
        AF.request("https://port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app/api/v1/diaries",method: .get, parameters: parameters, headers: headers).responseData { response in
            switch response.result {
                        case .success(let data):
                            do {
                                let decoder = JSONDecoder()
                                let responseModel = try decoder.decode(Response.self, from: data)
                                self.diaries = responseModel.data.diaries
                                self.DiaryMainTableView.reloadData()
                            } catch {
                                print("Decoding Error: \(error)")
                            }
                        case .failure(let error):
                            print("Request Error: \(error)")
                        }
        }
    }
    
    func convertDate(_ dateStr: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
            
        if let date = inputFormatter.date(from: dateStr) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ko_KR")
            outputFormatter.dateFormat = "yyyy년 MM월 dd일"
                
            return outputFormatter.string(from: date)
        } else {
            return dateStr
        }
    }
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return diaries.count > 0 ? diaries.count : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return diaries.count > 0 ? 526 : 585
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if diaries.count == 0 {
            
            let diaryCell = DiaryMainTableView.dequeueReusableCell(withIdentifier: emptycellReuseIdentifire, for: indexPath) as! DiaryMainEmptyTableViewCell
            
            return diaryCell
            
        } else {
            
            let diaryCell = DiaryMainTableView.dequeueReusableCell(withIdentifier: maincellReuseIdentifire, for: indexPath) as! DiaryMainTableViewCell
            let diary = diaries[indexPath.section]

            diaryCell.diaryDateLabel?.text = convertDate(diary.date)
            diaryCell.diaryDetailLabel?.text = diary.content
            diaryCell.diaryNameLabel?.text = diary.dogName + " 일기"
            diaryCell.diaryTitleLabel?.text = diary.title
            
            return diaryCell
            
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDiary = diaries[indexPath.section]
        
        if diaries.count == 0 {
            return
        }
        
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
