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
    
    // TableViewCell Xib 파일 이름 저장 프로퍼티
    let emptyCellName = "DiaryMainEmptyTableViewCell"
    let emptyCellReuseIdentifire = "DiaryEmptyCell"
    
    let mainCellName = "DiaryMainTableViewCell"
    let mainCellReuseIdentifire = "DiaryMainCell"
    
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
    var diaries: [Diary] = []
    var imageResponses: [ImageResponse.Data.Image] = []
    
    
    // 메인 로고 버튼
    @IBOutlet var meommuMainButton: UIBarButtonItem!
    
    // year, month 레이블 프로퍼티
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    
    // month 선택 피커 버튼
    @IBOutlet var diaryMonthPickerButton: UIButton!
    
    // 테이블 뷰 프로퍼티
    @IBOutlet var diaryMainTableView: UITableView!
    
    // 일기 작성 버튼 프로퍼티
    @IBOutlet var diaryWriteButton: UIButton!
    
    
    
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
        //⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData), name: NSNotification.Name("diaryDeleted"), object: nil)
        
        // NotificationCenter를 통해 일기 월별 필터링 알림 받기
        //⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidPickMonth(_:)), name: Notification.Name("DidPickMonth"), object: nil)
    }
    
    //MARK: - 레이블 셋업 메서드
    private func setupLabel() {
        yearLabel.text = "\(currentYear)년"
        monthLabel.text = "\(currentMonth)월"
    }
    
    //MARK: - 델리게이트 셋업 메서드
    private func setupDelegate() {
        diaryMainTableView.delegate = self
        diaryMainTableView.dataSource = self
    }
    
    
    //MARK: - 메인 버튼 탭 메서드
    @IBAction func meommuMainButtonTapped(_ sender: Any) {
        fetchData(year: currentYear, month: currentMonth)
    }
    
    // 일기 데이터 새로고침 메서드
    @objc func refreshData() {
        fetchData(year: currentYear, month: currentMonth)
    }
    
    
    //MARK: - month 선택 피커 탭 메서드
    // 바텀 시트 올리기
    // DiaryMonthPicker
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
    
    
    //MARK: - 전체 일기 조회 메서드 fetchData()
    private func fetchData(year: String, month: String) {
        // 일기 조회 REQ 생성
        let allDiaryREQ = AllDiaryRequest(year: year, month: month)
        
        // 일기 전체 조회
        DiaryAPI.shared.getAllDiary(with: allDiaryREQ) { result in
            switch result {
            case .success(let response):
                self.diaries = []
                
                self.diaries = response.data.diaries
                
                // 다이어리가 비어있을 경우 메서드를 종료한다.
                if self.diaries.isEmpty {
                    // 이미지 데이터가 없을 경우에도 UI를 업데이트합니다.
                    DispatchQueue.main.async {
                        self.diaryMainTableView.reloadData()
                    }
                    print("일기 없음")
                    return
                }
                
                print("이미지 조회 시작")
                
                // 이미지 요청 REQ 생성
                let getAllDiaryImageREQ = {
                    let imageIds = self.diaries.flatMap { $0.imageIds }
                    return ImageRequest(imageIds: imageIds)
                }()
                
                
                // 일기가 조회된 후 이미지도 조회한다.
                DiaryImageAPI.shared.getAllDiaryImage(with: getAllDiaryImageREQ) { result in
                    switch result {
                    case .success(let response):
                        // 이미지 URL을 저장한다.
                        if let data = response.data {
                            self.imageResponses = data.images
                        }
                        
                        // 이미지 데이터를 가져온 후에 UI를 업데이트합니다.
                        DispatchQueue.main.async {
                            self.diaryMainTableView.reloadData()
                        }
                        
                    case .failure(let error):
                        // 400~500 에러
                        print("Error: \(error.message)")
                    }
                }
                
            case .failure(let error):
                // 400~500 에러
                print("Error: \(error.message)")
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
        diaryMainTableView.register(nibName, forCellReuseIdentifier: mainCellReuseIdentifire)
    }
    //MARK: - 빈 일기 화면 셀 xib 등록 메서드
    private func registerXibEmpty() {
        let nibName = UINib(nibName: emptyCellName, bundle: nil)
        diaryMainTableView.register(nibName, forCellReuseIdentifier: emptyCellReuseIdentifire)
    }
    
    //MARK: - prepare 메서드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 셀이 선택되고 디테일 뷰가 열리기 전 특정 일기의 다이어리 데이터와 이미지 데이터를 디테일 뷰에 전달
        if segue.identifier == "ToDiaryDetailViewController" {
            if let diaryDetailVC = segue.destination as? DiaryDetailViewController,
               let selectedDiary = sender as? Diary {
                
                // 선택된 다이어리의 데이터를 디테일 뷰컨에 전달
                diaryDetailVC.diary = selectedDiary
                
                // 전체 일기의 이미지 배열에서 id와 url 데이터를 딕셔너리로 변경
                let imageResponseDict = Dictionary(uniqueKeysWithValues: imageResponses.map { ($0.id, $0.url) })
                
                print("이미지 딕셔너리: \(imageResponseDict)")
                
                // 선택된 일기의 이미지 URL을 찾아서 디테일VC에 넘겨줍니다.
                let imageUrls = selectedDiary.imageIds.compactMap { imageId in
                    imageResponseDict[imageId]
                }
                
                print("이미지 URLs: \(imageUrls)")
                diaryDetailVC.imageUrls = imageUrls
            }
            
        }
    }

    
    
}

//MARK: - UITableViewDataSource 확장
extension DiaryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.isEmpty ? 1 : diaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if diaries.isEmpty {
            // 다이어리가 비어 있을 경우 빈 화면 셀 보여주기
            let diaryCell = diaryMainTableView.dequeueReusableCell(withIdentifier: emptyCellReuseIdentifire, for: indexPath) as! DiaryMainEmptyTableViewCell
            
            return diaryCell
            
        } else {
            
            // 다이어리 데이터가 비어있지 않다면 일기 보여주기
            let diaryCell = diaryMainTableView.dequeueReusableCell(withIdentifier: mainCellReuseIdentifire, for: indexPath) as! DiaryMainTableViewCell
            
            let diary = diaries[indexPath.row]
            
            diaryCell.diaryDateLabel?.text = convertDate(diary.date)
            diaryCell.diaryDetailLabel?.text = diary.content
            diaryCell.diaryNameLabel?.text = diary.dogName + " 일기"
            diaryCell.diaryTitleLabel?.text = diary.title
            
            // 해당 셀의 이미지 id값으로 전체 이미지 URL 배열에서 해당 URL 받아오기.
            let imageUrls = diary.imageIds.compactMap { imageId in
                // imageResponses 배열에 안전하게 접근합니다.
                if let index = imageResponses.firstIndex(where: { $0.id == imageId }) {
                    return imageResponses[index].url
                } else {
                    return nil
                }
            }
            
            print("cell url \(diary.dogName): \(imageUrls)")
            // 해당 셀에 이미지 url 배열 전달
            diaryCell.imageUrls = imageUrls
            
            // 일기 셀의 수정 버튼에 액션 추가해주기 -> 수정 바텀 시트 띄우기
            diaryCell.diaryReviseAction = {
                
                // 수정, 삭제와 관련된 바텀 시트 생성 + 다이어리 전달
                let diaryReviseVC = DiaryReviseViewController.makeDiaryRevieceVCInstanse(diary: diary)

                // 바텀 시트 띄우기
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
        return DiaryMainTableViewCell.cellHeight
    }
    
    // 테이블 뷰 셀이 선택될 때 indexPath 전달
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return diaries.isEmpty ? nil : indexPath
    }
    
    
    // 셀이 선택될 때 전달 받은 인덱스를 통해 특정 일기 데이터를 세그웨이에 전달?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 선택된 셀의 인덱스를 통해 다이어리 배열에서 특정 일기 데이터를 넘겨준다.
        let selectedDiary = diaries[indexPath.row]
        performSegue(withIdentifier: "ToDiaryDetailViewController", sender: selectedDiary)
    }
    
    
}


