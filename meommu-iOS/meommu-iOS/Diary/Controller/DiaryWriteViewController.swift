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
import FloatingPanel

class DiaryWriteViewController: UIViewController, FloatingPanelControllerDelegate, PHPickerViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAvailableDate()
        createPickerView()
        
        todayDateSet()
        
        makeImageViewBorder()
        
        // -----------------------------------------
        // 1단계 바텀시트
        // 바텀시트 컨트롤러 생성하기
        fpc = FloatingPanelController()
        
        
        // 테두리 둥글게 설정하기
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 20.0
        
        fpc.surfaceView.appearance = appearance
        
        // 바텀시트 높이 고정 설정하기
        
        
        // delegate 설정
        fpc.delegate = self
        
        // 바텀시트에 표시할 컨텐츠 뷰 생성 및 설정
        let storyboard = UIStoryboard(name: "StepOne", bundle: nil)
        let stepOneVC = storyboard.instantiateViewController(withIdentifier: "StepOneViewController") as! StepOneViewController

        fpc.set(contentViewController: stepOneVC)
        
    }

    // -----------------------------------------
    // 1단계 바텀 시트 생성하기
    var fpc: FloatingPanelController!
    
    @IBOutlet var guideButton: UIButton!
    
    @IBAction func OnClick_guideButton(_ sender: Any) {
        present(fpc, animated: true, completion: nil)
    }
    
    // -----------------------------------------
    // 앨범에서 사진 추가하기
    
    @IBOutlet var imagePickerButton: UIButton!
    
    @IBOutlet var imageView5: UIImageView!
    @IBOutlet var imageView4: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView1: UIImageView!
    
    @IBAction func OnClick_imagePickerButton(_ sender: UIButton) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5 // 최대 선택 가능한 사진 개수
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            dismiss(animated: true, completion: nil)

            for (index, result) in results.enumerated() {
                if index == 0 {
                    loadImage(forImageView:imageView1 , with: result.itemProvider)
                } else if index == 1 {
                    loadImage(forImageView:imageView2 , with: result.itemProvider)
                } else if index == 2 {
                    loadImage(forImageView:imageView3 , with: result.itemProvider)
                } else if index == 3 {
                    loadImage(forImageView:imageView4 , with: result.itemProvider)
                } else if index == 4 {
                    loadImage(forImageView:imageView5 , with: result.itemProvider)
                }
                
                // 필요한 경우 더 많은 이미지뷰에 대한 처리 추가 가능
            }
            
           // 선택된 사진 수가 imageViews 배열의 크기보다 작을 경우 나머지 이미지뷰 초기화
           for i in results.count..<5 {
               switch i{
               case 0:
                   self.imageView1.image = nil
               case 1:
                   self.imageView2.image = nil
               case 2:
                   self.imageView3.image = nil
               case 3:
                   self.imageView4.image = nil
               case 4:
                   self.imageView5.image = nil
               default:
                   break;
              }
           }
       }

    private func loadImage(forImageView imageView:UIImageView?,with itemprovider:AnyObject?){
        let typeIdentifier:String?=(itemprovider as? NSExtensionItem)?.attachments?.first?.registeredTypeIdentifiers.first ?? itemprovider as? String
        let itemProvider = NSItemProvider()
          
        if typeIdentifier == UTType.image.identifier {
            itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    guard let image = image as? UIImage, let imageView = imageView else { return }
                    
                    UIView.transition(with: imageView, duration: .zero, options: .transitionCrossDissolve) {
                        imageView.image = image
                    }
                }
            }
          } else {
              print("Could not load image from item provider")
          }
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
    // 뒤로가기 버튼
    @IBOutlet var backButton: UIBarButtonItem!
    
    @IBAction func OnClick_backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // -----------------------------------------
    // DatePicker 기능
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var dateTextField: UITextField!
    
    // DatePicker에 필요한 변수 생성
    var availableYear: [Int] = []
    var allMonth: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    var allDate: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
    var selectedYear = 0
    var selectedMonth = 0
    var selectedDate = 0
    var todayYear = "0"
    var todayMonth = "0"
    var todayDate = "0"
    
    // PickerView 생성
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
    // 확인 버튼 클릭
    @objc func onPickDone() {
        yearLabel.text = "\(selectedYear)년"
        monthLabel.text = "\(selectedMonth)월"
        dateLabel.text = "\(selectedDate)일"
        
        dateTextField.resignFirstResponder()
    }
                
    // 취소 버튼 클릭
    @objc func onPickCancel() {
        dateTextField.resignFirstResponder()
    }
        
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
        formatterDate.dateFormat = "dd"
        todayDate = formatterDate.string(from: Date())
                    
        selectedYear = Int(todayYear)!
        selectedMonth = Int(todayMonth)!
        selectedDate = Int(todayDate)!
    }
}



// -----------------------------------------
// Date Picker 설정
extension DiaryWriteViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
        // 년, 월, 일 선택
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
                return ("\(allDate[row])일")
            default:
                return ""
        }
    }
    
    // 파커뷰에서 선택된 행을 처리할 수 있는 메서드
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
    }
    
}
