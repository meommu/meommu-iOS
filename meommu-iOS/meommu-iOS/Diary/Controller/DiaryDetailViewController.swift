//
//  DiaryDetailViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/25.
//

import UIKit
import AlamofireImage
import PanModal

// 아직 안된 기능: 공유하기 버튼, 이미지 스와이프(현재는 페이지 컨트롤 터치 시에만 이미지 넘김)

class DiaryDetailViewController: UIViewController {

    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var diaryReviseButton: UIBarButtonItem!
    
    @IBOutlet var diaryDateLabel: UILabel!
    @IBOutlet var diaryDetailLabel: UILabel!
    @IBOutlet var diaryTitleLabel: UILabel!
    @IBOutlet var diaryNameLabel: UILabel!
    @IBOutlet var diaryImageView: UIImageView!
    
    @IBOutlet var imagePageView: UIView!
    @IBOutlet var imagePageLabel: UILabel!
    
    @IBOutlet var diaryImagePageControl: UIPageControl!
    
    // 특정 일기 데이터 저장 프로퍼티
    var diary : DiaryResponse.Data.Diary?
    
    // 이미지 url 저장 프로포티
    var imageUrls: [String] = []
    
    //MARK: - viewDidLoad 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabel()
        setupPageControl()
        setupImage()
        setupView()
        
        
        // NotificationCenter를 통해 알림 받기
        NotificationCenter.default.addObserver(self, selector: #selector(self.diaryDeleted), name: NSNotification.Name("diaryDeleted"), object: nil)
        
    }
    
    
    
    //MARK: - 레이블 셋업 메서드
   private func setupLabel(){
        guard let selectedDiary = diary else { return }
        
        diaryDateLabel.text = convertDate(selectedDiary.date)
        diaryDetailLabel.text = selectedDiary.content
        diaryTitleLabel.text = selectedDiary.title
        diaryNameLabel.text = selectedDiary.dogName + " 일기"
    }
    
    //MARK: - 뷰 셋업 메서드
    private func setupView() {
        // imagePageView 테두리 둥글게
        imagePageView.layer.cornerRadius = 10
    }
    
    //MARK: - 이미지 셋업 메서드
    // 1. 이미지 보이기
    // 2. 이미지 페이지 레이블 수정
    private func setupImage() {
        if !imageUrls.isEmpty && diaryImagePageControl.currentPage < imageUrls.count {
            
            let imageUrl = imageUrls[diaryImagePageControl.currentPage]
            
            loadAndDisplayImage(from: imageUrl)
            
            // 이미지 페이지 업데이트
            imagePageLabel.text = "\(diaryImagePageControl.currentPage + 1) / \(imageUrls.count)"
            
        } else {
            // ❓ 일기를 생성할 때 이미지 1장은 필수이기 때문에 필요 없을 듯?
            
            // 이미지가 없는 경우를 처리합니다. 예를 들어, 기본 이미지를 표시하도록 설정할 수 있습니다.
            diaryImageView.image = UIImage(named: "defaultImage")
            
            // 이미지 페이지 업데이트
            imagePageLabel.text = "0 / \(imageUrls.count)"
        }
    }
    
    //MARK: - 이미지 url을 받으면 이미지 뷰를 변경시키는 메서드
    private func loadAndDisplayImage(from url: String) {
        if let imageUrl = URL(string: url) {
            diaryImageView.af.setImage(withURL: imageUrl)
        }
    }
    
    //MARK: - 페이지 컨트롤러 초기 셋업 메서드
    private func setupPageControl() {
        diaryImagePageControl.numberOfPages = imageUrls.count
        diaryImagePageControl.currentPage = 0
    }
    
    //MARK: - 일기 삭제 시 화면 전환 메서드
    @objc func diaryDeleted() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - 날짜 변환 메서드
    private func convertDate(_ dateStr: String) -> String {
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
    
    //MARK: - 일기 수정 버튼 탭 메서드
    @IBAction func diaryReviseButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DiaryRevise", bundle: nil)
        let diaryReviseVC = storyboard.instantiateViewController(withIdentifier: "DiaryReviseViewController") as! DiaryReviseViewController

        // 해당 일기의 id 값 전달
        diaryReviseVC.diaryId = diary?.id
        
        presentPanModal(diaryReviseVC)
    }

    
    
    //MARK: - 이전 버튼 탭 메서드
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func diaryimagePageChange(_ sender: UIPageControl) {
        setupImage()
    }
    
}
