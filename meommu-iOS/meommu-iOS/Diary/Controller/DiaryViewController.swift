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
    
    // 메인 로고 버튼
    @IBOutlet var MeommuMainButton: UIBarButtonItem!
    
    // year, month 레이블 프로퍼티
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    
    // month 선택 피커 버튼
    @IBOutlet var diaryMonthPickerButton: UIButton!
    
    // 테이블 뷰 프로퍼티
    @IBOutlet var DiaryMainTableView: UITableView!
    
    // 일기 작성 버튼 프로퍼티
    @IBOutlet var diaryWriteButton: UIButton!
    
    // 현재 year 저장 프로퍼티
    lazy var currentYear: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: Date())
    }()
    
    // 현재 month 저장 프로퍼티
    lazy var currentMonth: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter.string(from: Date())
    }()
    
    // 일기 데이터를 받을 프로퍼티 선언
    var diaries: [DiaryResponse.Data.Diary] = []
    var imageResponses: [ImageResponse.Data.Image] = []
    
    // TableViewCell Xib 파일 이름 저장 프로퍼티
    let emptyCellName = "DiaryMainEmptyTableViewCell"
    let emptyCellReuseIdentifire = "DiaryEmptyCell"
    
    let mainCellName = "DiaryMainTableViewCell"
    let mainCellReuseIdentifire = "DiaryMainCell"
    
    //MARK: - viewDidLoad 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupLabel()
        
        registerXibMain()
        registerXibEmpty()
        
        // 해당 year, month의 일기 불러오기
        fetchData(year: currentYear, month: currentMonth)
        
        // NotificationCenter를 통해 일기 삭제 알림 받기
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData), name: NSNotification.Name("diaryDeleted"), object: nil)
        
        // NotificationCenter를 통해 일기 월별 필터링 알림 받기
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidPickMonth(_:)), name: Notification.Name("DidPickMonth"), object: nil)
    }
    
    //MARK: - 레이블 셋업 메서드
    private func setupLabel() {
        yearLabel.text = "\(currentYear)년"
        monthLabel.text = "\(currentMonth)월"
    }
    
    //MARK: - 델리게이트 셋업 메서드
    private func setupDelegate() {
        DiaryMainTableView.delegate = self
        DiaryMainTableView.dataSource = self
    }
    
    
    //MARK: - 메인 버튼 탭 메서드
    @IBAction func meommuMainButtonTapped(_ sender: Any) {
        fetchData(year: currentYear, month: currentMonth)
    }
    
    @objc func refreshData() {
        fetchData(year: currentYear, month: currentMonth)
    }
    
    
    //MARK: - month 선택 피커 탭 메서드
    // 바텀 시트 올리기
    @IBAction func diaryMonthPickerButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DiaryMonthPicker", bundle: nil)
        let diaryMonthPickerVC = storyboard.instantiateViewController(withIdentifier: "DiaryMonthPickerViewController") as! DiaryMonthPickerViewController
        
        // 바텀 시트 띄우기
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
                
                // 이미지 ID 값만 배열에 저장
                let imageIds = self.diaries.flatMap { $0.imageIds }
                
                print("이미지 배열:\(imageIds)")
                
                // 이미지 ID가 없는 일기에 대해서는 요청을 보내지 않습니다.
                if !imageIds.isEmpty {
                    let urlString = "https://port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app/api/v1/images?" + imageIds.map { "id=\($0)" }.joined(separator: "&")
                    
                    // 이미지 id를 통해 이미지 불러오는 메서드
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
    
    //MARK: - 전달 받은 날짜 데이터를 형식에 맞게 전환하는 메서드
    private func convertDate(_ dateStr: String) -> String {
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
    
    //MARK: - 일기 화면 셀 xib 등록 메서드
    private func registerXibMain() {
        let nibName = UINib(nibName: mainCellName, bundle: nil)
        DiaryMainTableView.register(nibName, forCellReuseIdentifier: mainCellReuseIdentifire)
    }
    //MARK: - 빈 일기 화면 셀 xib 등록 메서드
    private func registerXibEmpty() {
        let nibName = UINib(nibName: emptyCellName, bundle: nil)
        DiaryMainTableView.register(nibName, forCellReuseIdentifier: emptyCellReuseIdentifire)
    }
}

//MARK: - UITableViewDataSource 확장
extension DiaryViewController: UITableViewDataSource {
    
    // ❗️
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return diaries.isEmpty ? 1 : diaries.count
    }
    
    
    // ❗️
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if diaries.isEmpty {
            // 다이어리가 비어 있을 경우 빈 화면 셀 보여주기
            let diaryCell = DiaryMainTableView.dequeueReusableCell(withIdentifier: emptyCellReuseIdentifire, for: indexPath) as! DiaryMainEmptyTableViewCell
            
            return diaryCell
            
        } else {
            // 다이어리 데이터가 비어있지 않다면 일기 보여주기
            let diaryCell = DiaryMainTableView.dequeueReusableCell(withIdentifier: mainCellReuseIdentifire, for: indexPath) as! DiaryMainTableViewCell
            let diary = diaries[indexPath.section]
            
            diaryCell.diaryDateLabel?.text = convertDate(diary.date)
            diaryCell.diaryDetailLabel?.text = diary.content
            diaryCell.diaryNameLabel?.text = diary.dogName + " 일기"
            diaryCell.diaryTitleLabel?.text = diary.title
            
            // 굳이 한 번더 확인..❓
            let imageUrls = diary.imageIds.compactMap { imageId in
                // imageResponses 배열에 안전하게 접근합니다.
                if let index = imageResponses.firstIndex(where: { $0.id == imageId }) {
                    return imageResponses[index].url
                } else {
                    return nil
                }
            }
            
            // 일기 셀에 이미지 설정 메서드
            diaryCell.setImageUrls(imageUrls)
            
            // 일기 셀의 수벙 버튼에 액션 추가해주기 -> 수정 바텀 시트 띄우기
            diaryCell.diaryReviseAction = {
                let storyboard = UIStoryboard(name: "DiaryRevise", bundle: nil)
                let diaryReviseVC = storyboard.instantiateViewController(withIdentifier: "DiaryReviseViewController") as! DiaryReviseViewController
                
                // 일기 수정 뷰컨에게 다이어리 id 전달
                diaryReviseVC.diaryId = diary.id
                
                self.presentPanModal(diaryReviseVC)
            }
            
            return diaryCell
            
        }
    }
}

//MARK: - UITableViewDelegate 확장

extension DiaryViewController: UITableViewDelegate {
    // 셀의 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // 테이블 뷰 셀이 선택될 때 indexPath 전달
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return diaries.isEmpty ? nil : indexPath
    }
    
    
    // 셀이 선택될 때 전달 받은 인덱스를 통해 특정 일기 데이터를 세그웨이에 전달?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택된 셀의 인덱스를 통해 다이어리 배열에서 특정 일기 데이터를 넘겨준다.
        let selectedDiary = diaries[indexPath.section]
        performSegue(withIdentifier: "showDetail", sender: selectedDiary)
    }
    
    // 셀이 선택되고 디테일 뷰가 열리기 전 특정 일기의 다이어리 데이터와 이미지 데이터를 디테일 뷰에 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let diaryDetailVC = segue.destination as? DiaryDetailViewController,
               let selectedDiary = sender as? DiaryResponse.Data.Diary {
                
                // 선택된 다이어리의 데이터를 디테일 뷰컨에 전달
                diaryDetailVC.diary = selectedDiary
                
                // 전체 일기의 이미지 배열에서 id와 url 데이터를 딕셔너리로 변경
                let imageResponseDict = Dictionary(uniqueKeysWithValues: imageResponses.map { ($0.id, $0.url) })
                
                print("이미지 딕셔너리: \(imageResponseDict)")
                
                // 선택되니 일기의 이미지 URL을 찾아서 디테일VC에 넘겨줍니다.
                let imageUrls = selectedDiary.imageIds.compactMap { imageId in
                    imageResponseDict[imageId]
                }
                
                print("이미지 URLs: \(imageUrls)")
                diaryDetailVC.imageUrls = imageUrls
            }
        }
    }
    
}


