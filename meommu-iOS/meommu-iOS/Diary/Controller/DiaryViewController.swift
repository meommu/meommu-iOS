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

        registerXibMain()
        registerXibEmpty()
        
        DiaryMainTableView.delegate = self
        DiaryMainTableView.dataSource = self
        
        setAvailableDate()
        createPickerView()
    }
    
    // -----------------------------------------
    // DatePicker 기능
    
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var diaryDatePickerButton: UIButton!
    @IBOutlet var diaryDateTextField: UITextField!
    
    // DatePicker에 필요한 변수 생성
    var availableYear: [Int] = []
    var allMonth: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    var selectedYear = 0
    var selectedMonth = 0
    var todayYear = "0"
    var todayMonth = "0"
    
    // PickerView 생성
    func createPickerView() {
                
        // 피커 세팅
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        diaryDateTextField.tintColor = .clear
        
        // 툴바 세팅
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
                
        let doneButton = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(onPickDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(onPickCancel))
        toolBar.setItems([cancelButton, space, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
                
        // 텍스트필드 입력 수단 연결
        diaryDateTextField.inputView = pickerView
        diaryDateTextField.inputAccessoryView = toolBar
    }
    
    // 확인 버튼 클릭
    @objc func onPickDone() {
        yearLabel.text = "\(selectedYear)년"
        monthLabel.text = "\(selectedMonth)월"
        
        diaryDateTextField.resignFirstResponder()
    }
            
    // 취소 버튼 클릭
    @objc func onPickCancel() {
        diaryDateTextField.resignFirstResponder()
    }
    
    // 가능한 날짜 설정
    func setAvailableDate() {
        // 선택 가능한 연도 설정
        let formatterYear = DateFormatter()
        formatterYear.dateFormat = "yyyy"
        todayYear = formatterYear.string(from: Date())
                
        for i in 2023...Int(todayYear)! {
            availableYear.append(i)
        }
                
        // 선택 가능한 달 설정
        let formatterMonth = DateFormatter()
        formatterMonth.dateFormat = "MM"
        todayMonth = formatterMonth.string(from: Date())
                
        selectedYear = Int(todayYear)!
        selectedMonth = Int(todayMonth)!
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

// Date Picker 설정
extension DiaryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
        // 년, 월 두 가지 선택
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
            case 0:
                return availableYear.count
            case 1:
                return allMonth.count
            default:
                return 0
        }
    }
        
    // 표출할 텍스트
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
            case 0:
                return "\(availableYear[row])년"
            case 1:
                return "\(allMonth[row])월"
            default:
                return ""
        }
    }
        
    // 파커뷰에서 선태된 행을 처리할 수 있는 메서드
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
            case 0:
                selectedYear = availableYear[row]
            case 1:
                selectedMonth = allMonth[row]
            default:
                break
        }
            
        if(Int(todayYear) == selectedYear && Int(todayMonth)! < selectedMonth){
            pickerView.selectRow(Int(todayMonth)!-1, inComponent: 1, animated: true)
            selectedMonth = Int(todayMonth)!
        }
    }
}

// TableView 설정
extension DiaryViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    // TableView 출력
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
}
