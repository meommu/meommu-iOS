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

        if let name = dogName {
            diaryContentTextField.placeholder = name + "의 일기를 작성해주세요."
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
    
    @IBOutlet var diaryContentTextField: UITextField!

    
    // -----------------------------------------
    // 일기 내용 작성 완료
    
    let AccessToken = "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6MjcsImlhdCI6MTcwMDYxMzk1OSwiZXhwIjoxNzAxMjE4NzU5fQ.AlQlq-YsMavw3QXJGUEx1FdV-CYdw2YUvhKqohb8JBFztmpl2gjtLPTujXPXEIRMC4MZV901xwVZNT6BbTuNcQ"
    
    @IBOutlet var diaryWriteButton: UIBarButtonItem!
    
    @IBAction func OnClick_diaryWriteButton(_ sender: Any) {
        
        guard let title = diaryTitleTextField.text, let content = diaryContentTextField.text, let dogName = dogName else { return }
        
        let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(AccessToken)"
            ]

            let parameters: [String: Any] = [
                "date": "\(yearLabel.text!.dropLast(1))-\(monthLabel.text!.dropLast(1))-\(dateLabel.text!.dropLast(1))",
                "dogName": dogName,
                "title": title,
                "content": content,
                "imageIds": selectedImages.map { _ in Int.random(in: 1...5) } // 이미지에 대한 id를 설정해주세요.
            ]

            AF.request("https://port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app/api/v1/diaries",
                       method: .post,
                       parameters: parameters,
                       encoding: JSONEncoding.default,
                       headers: headers)
                .response { response in
                    debugPrint(response)
            }
    }
    
    // -----------------------------------------
    // 뒤로가기 버튼
    @IBOutlet var backButton: UIBarButtonItem!
    
    @IBAction func OnClick_backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
