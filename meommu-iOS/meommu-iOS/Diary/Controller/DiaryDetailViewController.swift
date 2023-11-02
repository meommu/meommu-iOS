//
//  DiaryDetailViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/25.
//

import UIKit
import FloatingPanel

class DiaryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        
        // 바텀시트
        fpc = FloatingPanelController()
        
        let storyboard = UIStoryboard(name: "DiaryRevise", bundle: nil)
        let diaryReviseVC = storyboard.instantiateViewController(withIdentifier: "DiaryReviseViewController") as! DiaryReviseViewController
        
        fpc.set(contentViewController: diaryReviseVC)
        
        // 페이지 컨트롤 설정
        if let selectedDiary = diary {
                    imageArray = Array(selectedDiary.diaryImage) // 이미지 배열 초기화
                    diaryimagepageControl.numberOfPages = imageArray.count // 페이지 컨트롤 설정
                    diaryimagepageControl.currentPage = 0
                }
        
    }
    
    // -----------------------------------------
    // 일기 수정 및 삭제 바텀시트 생성하기
    var fpc: FloatingPanelController!
    
    @IBOutlet var diaryReviseButton: UIBarButtonItem!
    
    @IBAction func OnClick_diaryRiviseButton(_ sender: Any) {
        present(fpc, animated: true, completion: nil)
    }
    
    // -----------------------------------------
    // 뒤로 가기 버튼
    @IBOutlet var backButton: UIBarButtonItem!
    @IBAction func OnClick_BackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // -----------------------------------------
    // 전달 받은 데이터
    @IBOutlet var diaryDate: UILabel!
    @IBOutlet var diaryDetail: UILabel!
    @IBOutlet var diaryTitle: UILabel!
    @IBOutlet var diaryName: UILabel!
    @IBOutlet var diaryImageView: UIImageView!
    
    var diary : Diary?
    
    
    func updateUI(){
        guard let selectedDiary = diary else { return }
        
        diaryDate.text = selectedDiary.diaryDate
        diaryDetail.text = selectedDiary.diaryDetail
        diaryTitle.text = selectedDiary.diaryTitle
        diaryName.text = selectedDiary.diaryName + " 일기"
        
        if let imageName = selectedDiary.diaryImage.first,
           let image = UIImage(named: imageName) {
            diaryImageView.image = image
        }
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
