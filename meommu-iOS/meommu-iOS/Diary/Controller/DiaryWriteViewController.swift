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
import LDSwiftEventSource


class DiaryWriteViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, PHPickerViewControllerDelegate {
    
    // 유저가 선택한 가이드 데이터
    var guideData: [String] = [] {
        willSet(newVal) {
            newVal.forEach { val in
                guideDataString.append(val)
                // 가이드 구분을 위해 | 추가
                guideDataString.append("|")
                print(self.guideDataString)
            }
        }
    }
    
    // 서버 통신을 위해 유저의 가이드를 String으로 저장
    var guideDataString = ""
    
    // 강아지 이름
    var dogName: String?
    
    // 일기 수정 상황을 판단하는 프로퍼티 & 수정 시 바뀌는 일기 데이터
    var diaryData: DiaryIdResponse.Data?
    var isEdited: Bool?
    
    // 이미지 캐시 생성
    let imageCache = NSCache<NSString, UIImage>()
    
    // 일기 가이드 버튼
    @IBOutlet var diaryGuideButton: UIButton!
    // 백 버튼
    @IBOutlet var backButton: UIBarButtonItem!
    // 완료 버튼
    @IBOutlet var diaryWriteButton: UIBarButtonItem!
    
    //MARK: - viewDidLoad 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        
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
            
            // 이미지 ID를 사용하여 이미지 정보 가져오기
            if let imageIds = diaryData?.imageIds {
                var params: Parameters = [:]
                for id in imageIds {
                    params["id"] = id
                    AF.request("https://comibird.site/api/v1/images", parameters: params).responseDecodable(of: ImageUploadResponse.self) { response in
                        switch response.result {
                        case .success(let data):
                            let url = data.data.images.first?.url
                            DispatchQueue.global().async {
                                self.downloadImage(from: url) {
                                    DispatchQueue.main.async {
                                        
                                        self.imageArray.reverse()
                                        
                                        // 이미지 다운로드 완료, UI 업데이트
                                        self.diaryImageCollectionView.reloadData()
                                    }
                                }
                            }
                        case .failure(let error):
                            print("Image Info Error: \(error)")
                        }
                    }
                }
            }
            
        } else {
            todayDateSet()
        }
    }
    
    //MARK: - 델리게이트 셋업 메서드
    private func setupDelegate() {
        diaryImageCollectionView.delegate = self
        diaryImageCollectionView.dataSource = self
        
        diaryTitleTextField.delegate = self
        diaryContextTextView.delegate = self
    }
    
    
    //MARK: - 이전 버튼 탭 메서드
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - 이미지 배열에 전달해주는 메서드
    // 이미지 URL을 받아서 이미지를 다운로드하고, 다운로드한 이미지로 imageArray의 해당 위치의 nil 값을 교체하는 함수
    func downloadImage(from url: String?, completion: @escaping () -> Void) {
        guard let urlString = url else {
            print("Invalid URL")
            return
        }
        
        // 캐시된 이미지가 있는지 판단
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.imageArray.append(cachedImage)
            completion()
        } else {
            AF.download(urlString).responseData { response in
                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        self.imageArray.append(image)
                        self.imageCache.setObject(image, forKey: urlString as NSString)
                    }
                case .failure(let error):
                    print("Image Download Error: \(error)")
                }
                completion()
            }
        }
    }
    
    
    
    
    
    //MARK: - 일기 수정 요청 메서드
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
        
        let url = "https://comibird.site/api/v1/diaries/\(diaryId)"
        
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
    
    


    
    
    
  
    
    //MARK: - 멈무일기 가이드 버튼 탭 메서드
    @IBAction func diaryGuideButtonTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "DiaryGuide", bundle: nil)
        let stepOneVC = storyboard.instantiateViewController(withIdentifier: "DiaryGuideWirtePageViewController") as! DiaryGuideWirtePageViewController
        
        // userGuide 대리자 선정
        stepOneVC.writeVCDelegate = self
        
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
                // 이미지를 배열의 맨 뒤부터 표시
                cell.diaryImageView.image = imageArray[imageArray.count - indexPath.row]
                
                cell.onDelete = { [weak self] in
                    if let index = self?.imageArray.count {
                        // 이미지를 배열의 맨 뒤부터 삭제
                        self?.imageArray.remove(at: index - indexPath.row)
                        self?.diaryImageCollectionView.reloadData()
                    }
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
                        // 이미지를 배열의 맨 뒤에 추가
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
    
    
    //❗️사진, 제목, 글이 비어있을 때 얼럿 띄우기 기능 추가하기
    @IBAction func diaryWriteButtonTapped(_ sender: Any) {
        
        guard let title = diaryTitleTextField.text, let content = diaryContextTextView.text, let dogName = dogName else { return }
        
        var uploadedImageIds: [Int] = []
        let imageUploadGroup = DispatchGroup()
        
        
        // 이미지 순서 반전
        let orderedImageArray = isEdited == true ? imageArray : imageArray.reversed()
        
        
        
        if orderedImageArray.isEmpty {
            // 이미지가 없는 경우, 바로 api 호출
            if let isEdited = isEdited, isEdited {
                editDiary(diaryId: diaryData?.id ?? 0, title: title, content: content, dogName: dogName, imageIds: uploadedImageIds)
            } else {
                createDiary(title: title, content: content, dogName: dogName, imageIds: uploadedImageIds)
            }
        } else {
            // 이미지가 있는 경우, 이미지 업로드 후 일기 생성 API 호출
            orderedImageArray.forEach { image in
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
                }, to: "https://comibird.site/api/v1/images")
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
        
        AF.request("https://comibird.site/api/v1/diaries",
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

//MARK: - WirteVCDelegate 확장
extension DiaryWriteViewController: WirteVCDelegate {
    // 유저가 선택한 데이터 배열을 현재 VC에 저장한다.
    func getGuideData(_ data: [String]) {
        self.guideData = data
    }
    
    // SSE 방식으로 데이터를 수신하고 싶지만, 일단은 전체 데이터를 한 번에 받아서 보여주기. ❓
    func eventStart() {
        
        let request = GuideDataRequest(details: self.guideDataString)
        
        GPTDiaryAPI.shared.getGPTDiary(with: request) { result in
            switch result {
            case .success(let response):
                
                print(response)
                
                DispatchQueue.main.async {
                    // 일기 텍스트 뷰에 추가
                    self.diaryContextTextView.text = response.data.content
                }
                
            case .failure(let error):
                // 400~500 에러
                print("Error: \(error.message)")
            }
        }
        
        
        
//        guard let token = KeyChain.shared.read(key: KeyChain.shared.accessTokenKey) else {
//            return
//        }
//
//        // EventSource 오브젝트 생성
//        var config = EventSource.Config(handler: SseEventHandler(), url: URL(string: "https://comibird.site/api/v1/gpt/stream")!)
//
//        // 커스텀 요청 헤더를 명시
//        config.headers = ["Content-Type": "application/json;charset=UTF-8", "Authorization": "Bearer \(token)", "Content-Length": "76", "Host": "port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app"]
//
//
//        let body = GuideDataRequest(details: self.guideDataString)
//        let encoder = JSONEncoder()
//
//        if let encoded = try? encoder.encode(body) {
//            config.body = encoded
//            print("인코딩 성공")
//        }
//
//        // 최대 연결 유지 시간을 설정, 서버에 설정된 최대 연결 유지 시간보다 길게 설정
//
//        config.idleTimeout = 10000
//
//        print("컨피그: \(config)")
//
//        let eventSource = EventSource(config: config)
//
//        // EventSource 연결 시작
//        eventSource.start()
    }
    
}
