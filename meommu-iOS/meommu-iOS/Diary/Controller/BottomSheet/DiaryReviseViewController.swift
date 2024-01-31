//
//  DiaryReviseViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/30.
//

import UIKit
import Alamofire
import PanModal


class DiaryReviseViewController: UIViewController {

    // 일기 저장 프로퍼티
    var diary : Diary?
    
    // 일기 수정하기 버튼 프로퍼티
    @IBOutlet var diaryEditButton: UIButton!
    // 일기 삭제 버튼 프로퍼티
    @IBOutlet var diaryDeleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // 스토리보드로 해당 클래스 초기화 인스턴스를 리턴하는 메서드
    static func makeDiaryRevieceVCInstanse(diary: Diary) -> DiaryReviseViewController {
        let storyboard = UIStoryboard(name: "DiaryRevise", bundle: nil)
        let diaryReviseVC = storyboard.instantiateViewController(withIdentifier: "DiaryReviseViewController") as! DiaryReviseViewController
        
        // 일기를 전달한다.
        diaryReviseVC.diary = diary
        
        return diaryReviseVC
    }
    

    //MARK: - 다이어리 수정 버튼 탭 메서드
    @IBAction func diaryEditButtonTapped(_ sender: Any) {
        guard let diary else { return }
        
        let diaryWriteVC = DiarySendNameViewController.makeDiaryEditedVCInstance(diary: diary)

        diaryWriteVC.modalPresentationStyle = .fullScreen
        
        self.present(diaryWriteVC, animated: true, completion: nil)
    }
    
    
    //MARK: - 다이어리 삭제 버튼 탭 메서드
    @IBAction func diaryDeleteButtonTapped(_ sender: Any) {
        executeDeleteDiary()
    }

    // 다이어리 삭제 요첨 메서드
    private func executeDeleteDiary() {
        guard let diaryId = diary?.id else { return }
        
        DiaryAPI.shared.deletDiary(withId: diaryId) { result in
            switch result {
            case .success(let response):
                if response.code == "0000" {
                    print("Diary delete success")
                    // 성공 시, DiaryReviseViewController 닫기
                    self.dismiss(animated: true)
                    // 성공 시, NotificationCenter를 통해 알림 보내기
                    // ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
                    NotificationCenter.default.post(name: NSNotification.Name("diaryDeleted"), object: nil)
                }
            case .failure(let error):
                // 400~500 에러
                print("Error: \(error.message)")
            }
        }
        
    }
    
}

//MARK: - panModalPresentable 확장
extension DiaryReviseViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(161)  // 바텀 시트의 높이 설정
    }
    
    var cornerRadius: CGFloat {
        return 20.0  // 둥근 모서리 설정
    }
}

