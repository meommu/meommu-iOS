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
    
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var diaryReviseButton: UIBarButtonItem!
    
    @IBOutlet var diaryDateLabel: UILabel!
    @IBOutlet var diaryDetailLabel: UILabel!
    @IBOutlet var diaryTitleLabel: UILabel!
    @IBOutlet var diaryNameLabel: UILabel!
    
    @IBOutlet var imagePageView: UIView!
    @IBOutlet var imagePageLabel: UILabel!
    
    
    // 특정 일기 데이터 저장 프로퍼티
    var diary : Diary?
    
    // 이미지 url 저장 프로포티
    var imageUrls: [String] = []
    
    private var currentPageNumber = 1
    
    //MARK: - viewDidLoad 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageScrollView()
        setupLabel()
        setupView()
        
        // NotificationCenter를 통해 알림 받기
        // ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
        NotificationCenter.default.addObserver(self, selector: #selector(self.diaryDeleted), name: NSNotification.Name("diaryDeleted"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("뷰윌\(imageScrollView.frame)")
    }
    
    //MARK: - 이미지 관련 스크롤 뷰 셋업 메서드
    private func setupImageScrollView() {
        imageScrollView.isPagingEnabled = true
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.delegate = self
        
        // 이미지 추가 메서드
        addContentScrollView()
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
        // 이미지 페이지 업데이트
        imagePageLabel.text = "\(currentPageNumber) / \(imageUrls.count)"
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
        
        guard let diary else { return }
        
        // 수정 바텀시트 만들고, 일기 전달
        let diaryReviseVC = DiaryReviseViewController.makeDiaryRevieceVCInstanse(diary: diary)
        
        presentPanModal(diaryReviseVC)
    }
    
    
    
    //MARK: - 이전 버튼 탭 메서드
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - 공유하기 버튼 탭 메서드
    // 버튼 두 개 연결 중
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        DiaryAPI.shared.makeDiaryUUID(diaryId: self.diary?.id ?? 0) { result in
            print(self.diary?.id ?? 0)
            switch result {
            case .success(let response):
                // uuid 생성
                let uuid = response.data.uuid
                print(uuid)
                
                // activityVC 띄우기 (공유 기능)
                self.presentActivityVC(url: "https://meommu.site/diary/shared/\(uuid)")
                
            case .failure(let error):
                // 400~500 에러
                print("Error: \(error.message)")
            }
        }
        
        
    }
    
    //MARK: - ActivityVC 관련 메서드
    private func presentActivityVC(url: String) {
        // activityViewController 띄우기
        
        // 1. UIActivityViewController 초기화, 공유 아이템 지정
        let urlToShare: String = url

        let activityViewController = UIActivityViewController(activityItems : [ urlToShare], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail]

        self.present(activityViewController, animated: true, completion: nil)

        
        // 동작 완료 후 액션
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                print("share success")
            } else {
                print("share cancel")
            }
            if let shareError = error {
              print("share error")
            }
        }
    }
    
    
    
}

//MARK: - UIScrollViewDelegate 확장
extension DiaryDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(imageScrollView.contentOffset)
        print("width: \(imageScrollView.frame.size.width)")
        
        // 이미지 페이지 업데이트
        let currentPage =  Int((self.imageScrollView.contentOffset.x + (0.5 * self.imageScrollView.frame.size.width)) / self.imageScrollView.frame.width) + 1
        
        DispatchQueue.main.async {
            self.imagePageLabel.text = "\(currentPage) / \(self.imageUrls.count)"
        }

    }
    
    // 이미지를 스크롤 뷰에 추가하는 메서드
    func addContentScrollView() {
        // 이미지가 없는 경우 처리
        if imageUrls.isEmpty {
            addDefaultImageView()
            return
        }
        
        // 이미지가 있는 경우 각 이미지를 ScrollView에 추가
        for (index, imageUrl) in imageUrls.enumerated() {
            let imageView = createImageView(at: index, imageUrl: imageUrl)
            imageScrollView.addSubview(imageView)
        }
    }

    private func addDefaultImageView() {
        // 이미지가 없을 때 기본 이미지를 보여주는 ImageView 생성 및 추가
        let imageView = UIImageView(frame: imageScrollView.bounds)
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleToFill
        imageScrollView.contentSize.width = imageView.frame.width
        imageScrollView.addSubview(imageView)
    }

    private func createImageView(at index: Int, imageUrl: String) -> UIImageView {
        // 주어진 인덱스와 이미지 URL을 기반으로 ImageView 생성
        let imageView = UIImageView()
        let positionX = self.view.frame.size.width * CGFloat(index)
        
        imageView.frame = CGRect(x: positionX, y: 0, width: self.view.frame.width, height: imageScrollView.bounds.height)

        imageView.contentMode = .scaleToFill
        
        // 이미지 URL이 유효한 경우 해당 URL을 통해 이미지 설정
        if let imageURL = URL(string: imageUrl) {
            imageView.af.setImage(withURL: imageURL)
        }
        
        imageScrollView.contentSize.width = imageView.frame.width * CGFloat(index + 1)
        
        print("imagesScrollview.bound:\(imageScrollView.bounds)")
        print("self.view:\(self.view.frame)")
        print("imagesScrollview.frame:\(imageScrollView.frame)")
        print("imageview.frame\(index): \(imageView.frame)")
        
        return imageView
    }
    
    
    
    

}
