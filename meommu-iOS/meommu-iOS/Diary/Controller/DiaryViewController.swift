//
//  DiaryViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/17.
//

import UIKit
import Alamofire
import PanModal


class DiaryViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerXibMain()
        registerXibEmpty()
        
        DiaryMainTableView.delegate = self
        DiaryMainTableView.dataSource = self
        
        yearLabel.text = "\(current_year)년"
        monthLabel.text = "\(current_month)월"
        
        fetchData(year: current_year, month: current_month)
        
        // NotificationCenter를 통해 일기 삭제 알림 받기
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData), name: NSNotification.Name("diaryDeleted"), object: nil)
        
        // NotificationCenter를 통해 일기 월별 필터링 알림 받기
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidPickMonth(_:)), name: Notification.Name("DidPickMonth"), object: nil)
    }
    
    // -----------------------------------------
    // 데이터 새로고침하기
    
    @IBOutlet var MeommuButton: UIBarButtonItem!
    
    @IBAction func OnClick_MeommuButton(_ sender: Any) {
        fetchData(year: current_year, month: current_month)
    }
    
    @objc func refreshData() {
        fetchData(year: current_year, month: current_month)
    }
    
    // -----------------------------------------
    // 월별 필터링하기 바텀시트

    @IBOutlet var diaryMonthPickerButton: UIButton!
    
    @IBAction func OnClick_diaryMonthPickerButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DiaryMonthPicker", bundle: nil)
        let diaryMonthPickerVC = storyboard.instantiateViewController(withIdentifier: "DiaryMonthPickerViewController") as! DiaryMonthPickerViewController
        
        presentPanModal(diaryMonthPickerVC)
    }
    
    @objc func handleDidPickMonth(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let year = userInfo["year"] as? Int,
           let month = userInfo["month"] as? Int {
            
            // 라벨 업데이트
            yearLabel.text = "\(year)년"
            monthLabel.text = "\(month)월"
            
            // API 호출
            fetchData(year: "\(year)", month: "\(month)")
        }
    }


    
    // -----------------------------------------
    // 오늘 날짜 출력하기
    
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    
    lazy var current_year: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: Date())
    }()

    lazy var current_month: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter.string(from: Date())
    }()
    
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
    
    var diaries: [DiaryResponse.Data.Diary] = []
    var imageResponses: [ImageResponse.Data.Image] = []
    
    @IBOutlet var DiaryMainTableView: UITableView!
        
    // 키체인에서 엑세스 토큰 가져오기
    func getAccessTokenFromKeychain() -> String? {
        let key = KeyChain.shared.accessTokenKey
        let accessToken = KeyChain.shared.read(key: key)
        return accessToken
    }
    
    private func fetchData(year: String, month: String) {
        guard let accessToken = getAccessTokenFromKeychain() else {
            print("Access Token not found.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Host": "port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app"
        ]
        
        let parameters: Parameters = [
            "year": "\(year)",
            "month": "\(month)"
        ]
        
        AF.request("https://port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app/api/v1/diaries", method: .get, parameters: parameters, headers: headers).responseDecodable(of: DiaryResponse.self) { response in
            switch response.result {
            case .success(let diaryResponse):
                self.diaries = []
                
                self.diaries = diaryResponse.data.diaries
                
                // 이미지 데이터를 가져옵니다.
                let imageIds = self.diaries.flatMap { $0.imageIds }
                
                // 이미지 ID가 없는 일기에 대해서는 요청을 보내지 않습니다.
                if !imageIds.isEmpty {
                    let urlString = "https://port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app/api/v1/images?" + imageIds.map { "id=\($0)" }.joined(separator: "&")
                    
                    AF.request(urlString).responseDecodable(of: ImageResponse.self) { response in
                        switch response.result {
                        case .success(let imageResponse):
                            if let data = imageResponse.data {
                                self.imageResponses = data.images
                            }
                        case .failure(let error):
                            print(error)
                        }
                        
                        // 이미지 데이터를 가져온 후에도 UI를 업데이트합니다.
                        DispatchQueue.main.async {
                            self.DiaryMainTableView.reloadData()
                        }
                    }
                } else {
                    // 이미지 데이터가 없을 경우에도 UI를 업데이트합니다.
                    DispatchQueue.main.async {
                        self.DiaryMainTableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
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
        
        return diaries.isEmpty ? 1 : diaries.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return diaries.isEmpty ? 585 : 526
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if diaries.isEmpty {
            
            let diaryCell = DiaryMainTableView.dequeueReusableCell(withIdentifier: emptycellReuseIdentifire, for: indexPath) as! DiaryMainEmptyTableViewCell
            
            return diaryCell
            
        } else {
            
            let diaryCell = DiaryMainTableView.dequeueReusableCell(withIdentifier: maincellReuseIdentifire, for: indexPath) as! DiaryMainTableViewCell
            let diary = diaries[indexPath.section]

            diaryCell.diaryDateLabel?.text = convertDate(diary.date)
            diaryCell.diaryDetailLabel?.text = diary.content
            diaryCell.diaryNameLabel?.text = diary.dogName + " 일기"
            diaryCell.diaryTitleLabel?.text = diary.title
            
            let imageUrls = diary.imageIds.compactMap { imageId in
                // imageResponses 배열에 안전하게 접근합니다.
                if let index = imageResponses.firstIndex(where: { $0.id == imageId }) {
                    return imageResponses[index].url
                } else {
                    return nil
                }
            }
            diaryCell.setImageUrls(imageUrls)
            
            diaryCell.diaryReviseAction = {
                let storyboard = UIStoryboard(name: "DiaryRevise", bundle: nil)
                let diaryReviseVC = storyboard.instantiateViewController(withIdentifier: "DiaryReviseViewController") as! DiaryReviseViewController
                
                diaryReviseVC.diaryId = diary.id
                
                self.presentPanModal(diaryReviseVC)
            }
            
            return diaryCell
            
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return diaries.isEmpty ? nil : indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDiary = diaries[indexPath.section]
        performSegue(withIdentifier: "showDetail", sender: selectedDiary)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let vc = segue.destination as? DiaryDetailViewController,
               let selectedDiary = sender as? DiaryResponse.Data.Diary {
                vc.diary = selectedDiary
                
                // 이미지 응답을 딕셔너리로 변환합니다.
                let imageResponseDict = Dictionary(uniqueKeysWithValues: imageResponses.map { ($0.id, $0.url) })

                // 이미지 URL을 찾아서 DiaryDetailViewController에 넘겨줍니다.
                let imageUrls = selectedDiary.imageIds.compactMap { imageId in
                    imageResponseDict[imageId]
                }
                vc.imageUrls = imageUrls
            }
        }
    }
    
}

