//
//  DiaryDetailViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/25.
//

import UIKit


class DiaryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        
        // 바텀시트
        
        
        // 페이지 컨트롤 설정
        /*if let selectedDiary = diary as? Diary {
         imageArray = Array(selectedDiary.diaryImage) // 이미지 배열 초기화
         diaryimagepageControl.numberOfPages = imageArray.count // 페이지 컨트롤 설정
         diaryimagepageControl.currentPage = 0
     }
         */
        
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
            
            // 이미지는 일단 생략하고, 다른 데이터를 채워봅니다.
        }
    
    // -----------------------------------------
    // 이미지 페이지 컨트롤
    
    var imageArray: [String] = [] // 이미지 저장 배열
    
    @IBOutlet var diaryimagepageControl: UIPageControl!
    
    @IBAction func diaryimagePageChange(_ sender: UIPageControl) {
        
        let currentPageIndex = sender.currentPage < imageArray.count ? sender.currentPage : 0
        
        let imageName = imageArray[currentPageIndex]
        if let image = UIImage(named:imageName) {
            diaryImageView.image = image
        }
    }
    

}
