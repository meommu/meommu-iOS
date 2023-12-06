//
//  DiaryWriteViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/19.
//

import UIKit
import PhotosUI
import MobileCoreServices
import UniformTypeIdentifiers
import Alamofire
import PanModal


class DiaryWriteViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, PHPickerViewControllerDelegate {
    
    
    var dogName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        diaryImageCollectionView.delegate = self
        diaryImageCollectionView.dataSource = self
        
        diaryTitleTextField.delegate = self
        diaryContextTextView.delegate = self
        
        if let name = dogName {
            diaryContextTextView.text = dogName! + "의 일기를 작성해 주세요.(0/1000)"
            diaryContextTextView.textColor = .lightGray
        }
        
        // 데이트 피커
        setAvailableDate()
        createPickerView()
        
        // isEdited가 true인 경우 데이터 설정
        if let isEdited = isEdited, isEdited {
            if let date = diaryData?.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                if let actualDate = formatter.date(from: date) {
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year, .month, .day], from: actualDate)
                    yearLabel.text = "\(components.year ?? 0)년"
                    monthLabel.text = String(format: "%02d", components.month ?? 0) + "월"
                    dateLabel.text = String(format: "%02d", components.day ?? 0) + "일"
                }
            }
            diaryTitleTextField.text = diaryData?.title
            diaryContextTextView.text = diaryData?.content
        } else {
            todayDateSet()
        }
    }
    
    // -----------------------------------------
    // 일기 수정하기
    var diaryData: DiaryIdResponse.Data?
    var isEdited: Bool?
    
    private func editDiary(diaryId: Int, title: String, content: String, dogName: String, imageIds: [Int]) {
        
        guard let accessToken = getAccessTokenFromKeychain() else {
            print("Access Token not found.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let parameters: [String: Any] = [
            "date": "\(yearLabel.text!.dropLast(1))-\(monthLabel.text!.dropLast(1))-\(dateLabel.text!.dropLast(1))",
            "dogName": dogName,
            "title": title,
            "content": content,
            "imageIds": imageIds
        ]
        
        let url = "https://port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app/api/v1/diaries/\(diaryId)"
        
        AF.request(url,
                   method: .put,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .response { [self] response in
            debugPrint(response)
            
            
            // API 호출이 완료되면 메인 화면으로 이동
            DispatchQueue.main.async { [weak self] in
                let newStoryboard = UIStoryboard(name: "Diary", bundle: nil)
                let newViewController = newStoryboard.instantiateViewController(identifier: "DiaryViewController")
                self?.changeRootViewController(newViewController)
            }
        }
    }
    
    // -----------------------------------------
    // 1단계 바텀시트
    @IBOutlet var diaryGuideButton: UIButton!
    
    @IBAction func OnClick_diaryGuideButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "DiaryGuide", bundle: nil)
        let stepOneVC = storyboard.instantiateViewController(withIdentifier: "StepOneViewController") as! StepOneViewController
        
        presentPanModal(stepOneVC)
    }
    
    
    // -----------------------------------------
    // 앨범에서 사진 추가하기
    @IBOutlet var diaryImageCollectionView: UICollectionView!
    
    var imageArray = [UIImage]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = diaryImageCollectionView.dequeueReusableCell(withReuseIdentifier: "DiaryImageButtonCell", for: indexPath) as! DiaryImageButtonCollectionViewCell
            cell.diaryImagePickerButton.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addImage))
            cell.diaryImagePickerButton.addGestureRecognizer(tapGesture)
            
            cell.diaryImageCountLabel.text = "\(imageArray.count) / 5"
            
            return cell
        } else {
            if indexPath.row <= imageArray.count {
                let cell = diaryImageCollectionView.dequeueReusableCell(withReuseIdentifier: "DiaryImageCell", for: indexPath) as! DiaryImageCollectionViewCell
                cell.diaryImageView.image = imageArray[indexPath.row - 1]
                
                // 삭제 버튼 클릭 시 실행될 클로저 설정
                cell.onDelete = { [weak self] in
                    self?.imageArray.remove(at: indexPath.row - 1)
                    self?.diaryImageCollectionView.reloadData()
                }
                
                return cell
            } else {
                let cell = diaryImageCollectionView.dequeueReusableCell(withReuseIdentifier: "DiaryImageEmptyCell", for: indexPath) as! DiaryImageEmptyCollectionViewCell
                return cell
            }
        }
    }
    
    @objc func addImage() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5 - imageArray.count
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
   
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.imageArray.append(image)
                        self?.diaryImageCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    // 권한 설정
    private func showPermissionAlert() {
        let alert = UIAlertController(title:"앨범 접근 권한 필요", message:"사진을 선택하기 위해 앨범 접근 권한이 필요합니다. 설정에서 앨범 접근 권한을 허용해주세요.", preferredStyle:.alert)
        
        alert.addAction(UIAlertAction(title:"설정으로 이동", style:.default) { _ in
            guard let settingsURL = URL(string:UIApplication.openSettingsURLString) else { return }
            
            UIApplication.shared.open(settingsURL)
        })
        
        alert.addAction(UIAlertAction(title:"취소", style:.cancel))
        
        present(alert, animated:true)
    }
    
    
    // -----------------------------------------
    // 오늘 날짜 출력하기
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var dateTextField: UITextField!
    
    func todayDateSet(){
        // 년
        let formatter_year = DateFormatter()
        formatter_year.dateFormat = "yyyy"
        let current_year = formatter_year.string(from: Date())
        
        // 월
        let formatter_month = DateFormatter()
        formatter_month.dateFormat = "MM"
        let current_month = formatter_month.string(from: Date())
        
        // 일
        let formatter_date = DateFormatter()
        formatter_date.dateFormat = "dd"
        let current_date = formatter_date.string(from: Date())
        
        yearLabel.text = "\(current_year)년"
        monthLabel.text = "\(current_month)월"
        dateLabel.text = "\(current_date)일"
    }
    
    // DatePicker 기능
    // -- DatePicker에 필요한 변수 생성
    var availableYear: [Int] = []
    var allMonth: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    var allDate: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
    var selectedYear = 0
    var selectedMonth = 0
    var selectedDate = 0
    var todayYear = "0"
    var todayMonth = "0"
    var todayDate = "0"
    
    // -- PickerView 생성
    func createPickerView() {
        
        // 피커 세팅
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        dateTextField.tintColor = .clear
        
        // 툴바 세팅
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(onPickDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(onPickCancel))
        toolBar.setItems([cancelButton, space, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        // 텍스트필드 입력 수단 연결
        dateTextField.inputView = pickerView
        dateTextField.inputAccessoryView = toolBar
    }
    
    // -- 확인 버튼 클릭
    @objc func onPickDone() {
        yearLabel.text = "\(selectedYear)년"
        monthLabel.text = String(format: "%02d", selectedMonth) + "월"
        dateLabel.text = String(format: "%02d", selectedDate) + "일"
        
        dateTextField.resignFirstResponder()
    }
    
    // -- 취소 버튼 클릭
    @objc func onPickCancel() {
        dateTextField.resignFirstResponder()
    }
    
    // -- 가능한 날짜 설정
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
        
        // 선택 가능한 일 설정
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "DD"
        todayDate = formatterDate.string(from: Date())
        
        selectedYear = Int(todayYear)!
        selectedMonth = Int(todayMonth)!
        selectedDate = Int(todayDate)!
    }
    
    
    // -----------------------------------------
    // 일기 내용 작성
    @IBOutlet var diaryTitleTextField: UITextField!
    @IBOutlet var diaryContextTextView: UITextView!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 20
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 1000
    }
    
    
    // -----------------------------------------
    // 일기 내용 작성 완료
    
    @IBOutlet var diaryWriteButton: UIBarButtonItem!
    
    @IBAction func OnClick_diaryWriteButton(_ sender: Any) {
        
        guard let title = diaryTitleTextField.text, let content = diaryContextTextView.text, let dogName = dogName else { return }
        
        var uploadedImageIds: [Int] = []
        let imageUploadGroup = DispatchGroup()
        
        
        if imageArray.isEmpty {
            // 이미지가 없는 경우, 바로 api 호출
            if let isEdited = isEdited, isEdited {
                editDiary(diaryId: diaryData?.id ?? 0, title: title, content: content, dogName: dogName, imageIds: uploadedImageIds)
            } else {
                createDiary(title: title, content: content, dogName: dogName, imageIds: uploadedImageIds)
            }
        } else {
            // 이미지가 있는 경우, 이미지 업로드 후 일기 생성 API 호출
            imageArray.forEach { image in
                imageUploadGroup.enter()
                
                AF.upload(multipartFormData: { multipartFormData in
                    let imageData: Data
                    let mimeType: String
                    
                    if let jpegData = image.jpegData(compressionQuality: 0.5) {
                        // JPEG으로 변환 가능하면서 30MB 이하인 경우
                        guard jpegData.count <= 30 * 1024 * 1024 else { return }
                        imageData = jpegData
                        mimeType = "image/jpeg"
                    } else if let pngData = image.pngData() {
                        // PNG로 변환 가능하면서 30MB 이하인 경우
                        guard pngData.count <= 30 * 1024 * 1024 else { return }
                        imageData = pngData
                        mimeType = "image/png"
                    } else {
                        // 변환 불가능한 경우, 기본적으로 JPEG로 설정
                        imageData = image.jpegData(compressionQuality: 0.5) ?? Data()
                        mimeType = "image/jpeg"
                    }
                    
                    multipartFormData.append(imageData, withName: "images", fileName: "image.\(mimeType)", mimeType: mimeType)
                    multipartFormData.append("DIARY_IMAGE".data(using: .utf8)!, withName: "category")
                }, to: "https://port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app/api/v1/images")
                .responseDecodable(of: ImageUploadResponse.self) { response in
                    switch response.result {
                    case .success(let imageUploadResponse):
                        uploadedImageIds.append(contentsOf: imageUploadResponse.data.images.map { $0.id })
                    case .failure(let error):
                        print("Image Upload Error: \(error)")
                    }
                    imageUploadGroup.leave()
                }
            }
            
            imageUploadGroup.notify(queue: .main) {
                if let isEdited = self.isEdited, isEdited {
                    self.editDiary(diaryId: self.diaryData?.id ?? 0, title: title, content: content, dogName: dogName, imageIds: uploadedImageIds)
                } else {
                    self.createDiary(title: title, content: content, dogName: dogName, imageIds: uploadedImageIds)
                }
            }
            
        }
    }
    
    // 키체인에서 엑세스 토큰 가져오기
    func getAccessTokenFromKeychain() -> String? {
        let key = KeyChain.shared.accessTokenKey
        let accessToken = KeyChain.shared.read(key: key)
        return accessToken
    }
    
    private func createDiary(title: String, content: String, dogName: String, imageIds: [Int]) {
        
        guard let accessToken = getAccessTokenFromKeychain() else {
            print("Access Token not found.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let parameters: [String: Any] = [
            "date": "\(yearLabel.text!.dropLast(1))-\(monthLabel.text!.dropLast(1))-\(dateLabel.text!.dropLast(1))",
            "dogName": dogName,
            "title": title,
            "content": content,
            "imageIds": imageIds
        ]
        
        AF.request("https://port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app/api/v1/diaries",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .response { response in
            debugPrint(response)
            
            // API 호출이 완료되면 메인 화면으로 이동
            DispatchQueue.main.async { [weak self] in
                let newStoryboard = UIStoryboard(name: "Diary", bundle: nil)
                let newViewController = newStoryboard.instantiateViewController(identifier: "DiaryViewController")
                self?.changeRootViewController(newViewController)
            }
        }
    }
    
    // UIWindow의 rootViewController를 변경하여 화면전환 함수
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = viewControllerToPresent
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        } else {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    // -----------------------------------------
    // 뒤로가기 버튼
    @IBOutlet var backButton: UIBarButtonItem!
    
    @IBAction func OnClick_backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension DiaryWriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "\(dogName!)의 일기를 작성해 주세요.(0/1000)" {
            textView.text = ""
            textView.textColor = UIColor(named: "Gray500")
        }
    }
            
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "\(dogName!)의 일기를 작성해 주세요.(0/1000)"
            textView.textColor = UIColor(named: "Gray300")
        }
    }
}

// Date Picker 설정
extension DiaryWriteViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
        // 년, 월, 일 두 가지 선택
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
            case 0:
                return availableYear.count
            case 1:
                return allMonth.count
            case 2:
                return allDate.count
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
        case 2:
            return "\(allDate[row])일"
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
        case 2:
            selectedDate = allDate[row]
        default:
            break
        }

        if(Int(todayYear) == selectedYear && Int(todayMonth)! < selectedMonth){
            pickerView.selectRow(Int(todayMonth)!-1, inComponent: 1, animated: true)
            selectedMonth = Int(todayMonth)!
        }
    }
}
