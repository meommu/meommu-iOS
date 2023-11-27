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
import FittedSheets
import Alamofire


class DiaryWriteViewController: UIViewController, PHPickerViewControllerDelegate {
    
    var dogName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todayDateSet()
        
        makeImageViewBorder()
        
        // 앨범에서 이미지 추가하기
        // UIImageView 배열 초기화
        imageViews = [imageView1, imageView2, imageView3, imageView4, imageView5]
        
        // 이미지 피커 버튼에 액션 추가
        imagePickerButton.addTarget(self, action: #selector(OnClick_imagePickerButton(_:)), for: .touchUpInside)

        diaryContextTextView.delegate = self
        
        if let name = dogName {
            diaryContextTextView.text = dogName! + "의 일기를 작성해 주세요.(0/1000)"
            diaryContextTextView.textColor = .lightGray
        }
        
    }
    
    
    
    // -----------------------------------------
    // 1단계 바텀시트
    @IBOutlet var diaryGuideButton: UIButton!
    
    @IBAction func OnClick_diaryGuideButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DiaryGuide", bundle: nil)
        
        guard let stepOneViewController = storyboard.instantiateViewController(withIdentifier: "StepOneViewController") as? StepOneViewController else {return}
        
        let sheetController = SheetViewController(controller: stepOneViewController, sizes: [.fixed(562)])
        sheetController.dismissOnPull = false
        sheetController.dismissOnOverlayTap = true
        self.present(sheetController, animated: true, completion: nil)
        
    }

    
    // -----------------------------------------
    // 앨범에서 사진 추가하기
    
    @IBOutlet var imagePickerButton: UIButton!
    
    @IBOutlet var imageView5: UIImageView!
    @IBOutlet var imageView4: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView1: UIImageView!
    
    var imageViews: [UIImageView] = []
    var selectedImages: [UIImage] = []
    
    @objc func OnClick_imagePickerButton(_ sender: UIButton) {
        let status = PHPhotoLibrary.authorizationStatus()
            
            switch status {
            case .authorized:
                presentPicker()
                
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { [weak self] status in
                    if status == .authorized {
                        DispatchQueue.main.async { [weak self] in
                            self?.presentPicker()
                        }
                    } else {
                        DispatchQueue.main.async { [weak self] in
                            self?.showPermissionAlert()
                        }
                    }
                }
                
            default:
                showPermissionAlert()
            }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] imageOrNil, error in
                    if let image = imageOrNil as? UIImage {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            
                            // 선택한 이미지를 배열에 추가하고 이미지 뷰에 표시
                            self.selectedImages.append(image)
                            
                            if let emptyImageViewIndex = self.imageViews.firstIndex(where: { $0.image == nil }) {
                                self.imageViews[emptyImageViewIndex].image = image
                            }
                        }
                    }
                }
            } else {
                print("이미지 로드 실패")
            }
            
            if selectedImages.count >= 5 {
                break  // 이미지를 모두 선택했으면 반복문 종료
            }
        }
    }
    
    private func presentPicker(){
        var configuration = PHPickerConfiguration()
                
        // 사진 선택 개수 제한 (여기서는 최대 5장)
        configuration.selectionLimit = 5 - selectedImages.count
            
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
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
    // 이미지뷰 테두리 만들기
    @IBOutlet var borderView5: UIView!
    @IBOutlet var borderView4: UIView!
    @IBOutlet var borderView3: UIView!
    @IBOutlet var borderView2: UIView!
    @IBOutlet var borderView1: UIView!
    
    func makeImageViewBorder(){
        
        // 이미지뷰 테두리 둥글게
        imageView1?.layer.cornerRadius = 4
        imageView2?.layer.cornerRadius = 4
        imageView3?.layer.cornerRadius = 4
        imageView4?.layer.cornerRadius = 4
        imageView5?.layer.cornerRadius = 4
        
        // 테두리 둥글게
        borderView1?.layer.cornerRadius = 4
        borderView2?.layer.cornerRadius = 4
        borderView3?.layer.cornerRadius = 4
        borderView4?.layer.cornerRadius = 4
        borderView5?.layer.cornerRadius = 4
        // 테두리 두께
        borderView1?.layer.borderWidth = 2
        borderView2?.layer.borderWidth = 2
        borderView3?.layer.borderWidth = 2
        borderView4?.layer.borderWidth = 2
        borderView5?.layer.borderWidth = 2
        // 테두리 컬러
        borderView1?.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        borderView2?.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        borderView3?.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        borderView4?.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        borderView5?.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        // 배경색 투명하게
        borderView1.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
        borderView2.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
        borderView3.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
        borderView4.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
        borderView5.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
        borderView1?.isOpaque = false
        borderView2?.isOpaque = false
        borderView3?.isOpaque = false
        borderView4?.isOpaque = false
        borderView5?.isOpaque = false
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
    
    
    // -----------------------------------------
    // 일기 내용 작성
    @IBOutlet var diaryTitleTextField: UITextField!
    @IBOutlet var diaryContextTextView: UITextView!
    
    
    // -----------------------------------------
    // 일기 내용 작성 완료
    
    let AccessToken = "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6NiwiaWF0IjoxNzAxMDAxMjUwLCJleHAiOjE3MDE2MDYwNTB9.d8HZ_LrgFNxBNPmdXBBxw3c7OvoEdukOYxP-Kqepkz6IFn8jiNvrGjEjFhm37UWtX6a3Qeb2YYVFMIdBsHC9FA"
    
    @IBOutlet var diaryWriteButton: UIBarButtonItem!
    
    @IBAction func OnClick_diaryWriteButton(_ sender: Any) {
        
        guard let title = diaryTitleTextField.text, let content = diaryContextTextView.text, let dogName = dogName else { return }
        
        var uploadedImageIds: [Int] = []
        let imageUploadGroup = DispatchGroup()
        
        if selectedImages.isEmpty {
            // 이미지가 없는 경우, 바로 일기 생성 API 호출
            createDiary(title: title, content: content, dogName: dogName, imageIds: uploadedImageIds)
        } else {
            // 이미지가 있는 경우, 이미지 업로드 후 일기 생성 API 호출
            selectedImages.forEach { image in
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
                self.createDiary(title: title, content: content, dogName: dogName, imageIds: uploadedImageIds)
            }
            
        }
    }
    
    private func createDiary(title: String, content: String, dogName: String, imageIds: [Int]) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(AccessToken)"
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
            textView.textColor = .black
        }
    }
            
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "\(dogName!)의 일기를 작성해 주세요.(0/1000)"
            textView.textColor = .lightGray
        }
    }
}
