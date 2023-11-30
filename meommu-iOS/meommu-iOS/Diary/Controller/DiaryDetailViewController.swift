//
//  DiaryDetailViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/25.
//

import UIKit
import AlamofireImage
import PanModal


class DiaryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        setupPageControl()
        updateImage()
        
        // imagePageView 테두리 둥글게
        imagePageView.layer.cornerRadius = 10
        
        // NotificationCenter를 통해 알림 받기
        NotificationCenter.default.addObserver(self, selector: #selector(self.diaryDeleted), name: NSNotification.Name("diaryDeleted"), object: nil)
        
    }
    
    // -----------------------------------------
    // 일기 수정 및 삭제 바텀시트 생성하기
    
    @IBOutlet var diaryReviseButton: UIBarButtonItem!
    
    @IBAction func OnClick_diaryReviseButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DiaryRevise", bundle: nil)
        let diaryReviseVC = storyboard.instantiateViewController(withIdentifier: "DiaryReviseViewController") as! DiaryReviseViewController

        diaryReviseVC.diaryId = diary?.id
        
        presentPanModal(diaryReviseVC)
    }

    @objc func diaryDeleted() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // -----------------------------------------
    // 뒤로 가기 버튼
    @IBOutlet var backButton: UIBarButtonItem!
    @IBAction func OnClick_BackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // -----------------------------------------
    // 전달 받은 데이터 조회하기
    @IBOutlet var diaryDate: UILabel!
    @IBOutlet var diaryDetail: UILabel!
    @IBOutlet var diaryTitle: UILabel!
    @IBOutlet var diaryName: UILabel!
    @IBOutlet var diaryImageView: UIImageView!
    
    var diary : DiaryResponse.Data.Diary?
    
    func convertDate(_ dateStr: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateStr) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ko_KR") // 한국어로 출력
            outputFormatter.dateFormat = "yyyy년 MM월 dd일"
            
            return outputFormatter.string(from: date)
        } else {
            return dateStr
        }
    }
    
    func updateUI(){
        guard let selectedDiary = diary else { return }
        
        diaryDate.text = convertDate(selectedDiary.date)
        diaryDetail.text = selectedDiary.content
        diaryTitle.text = selectedDiary.title
        diaryName.text = selectedDiary.dogName + " 일기"
    }
    
    // -----------------------------------------
    // 이미지 가져오기 및 컨트롤
    
    @IBOutlet var imagePageView: UIView!
    @IBOutlet var imagePageLabel: UILabel!
    
    var imageUrls: [String] = []
    
    func updateImage() {
        if !imageUrls.isEmpty && diaryimagepageControl.currentPage < imageUrls.count {
            let imageUrl = imageUrls[diaryimagepageControl.currentPage]
            loadAndDisplayImage(from: imageUrl)
            
            // 이미지 페이지 업데이트
            imagePageLabel.text = "\(diaryimagepageControl.currentPage + 1) / \(imageUrls.count)"
            
        } else {
            // 이미지가 없는 경우를 처리합니다. 예를 들어, 기본 이미지를 표시하도록 설정할 수 있습니다.
            diaryImageView.image = UIImage(named: "defaultImage")
            
            // 이미지 페이지 업데이트
            imagePageLabel.text = "0 / \(imageUrls.count)"
        }
    }
    
    func loadAndDisplayImage(from url: String) {
        if let imageUrl = URL(string: url) {
            diaryImageView.af.setImage(withURL: imageUrl)
        }
    }
    
    func setupPageControl() {
        diaryimagepageControl.numberOfPages = imageUrls.count
        diaryimagepageControl.currentPage = 0
    }
    
    @IBOutlet var diaryimagepageControl: UIPageControl!
    
    @IBAction func diaryimagePageChange(_ sender: UIPageControl) {
        updateImage()
    }
    

}
