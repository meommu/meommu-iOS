//
//  DiaryDetailViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/25.
//

import UIKit
import AlamofireImage


class DiaryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        setupPageControl()
        updateImage()
    }
    
    // -----------------------------------------
    // 일기 수정 및 삭제 바텀시트 생성하기
    
    
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
    
    var imageUrls: [String] = []
    
    func updateImage() {
        let currentPageIndex = diaryimagepageControl.currentPage < imageUrls.count ? diaryimagepageControl.currentPage : 0
        
        let imageUrl = imageUrls[currentPageIndex]
        loadAndDisplayImage(from: imageUrl)
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
