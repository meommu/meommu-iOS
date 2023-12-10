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
    
    // 일기 수정하기 버튼 프로퍼티
    @IBOutlet var diaryEditButton: UIButton!
    // 일기 삭제 버튼 프로퍼티
    @IBOutlet var diaryDeleteButton: UIButton!
    
    // 해당 다이어리 id를 받기 위한 프로퍼티
    var diaryId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // 키체인에서 엑세스 토큰 가져오기
    func getAccessTokenFromKeychain() -> String? {
        let key = KeyChain.shared.accessTokenKey
        let accessToken = KeyChain.shared.read(key: key)
        return accessToken
    }
    

    //MARK: - 다이어리 수정 버튼 탭 메서드
    @IBAction func diaryEditButtonTapped(_ sender: Any) {
        guard let diaryId = diaryId else { return }
        
        print("다이어라 id: \(diaryId)")
        
        guard let accessToken = getAccessTokenFromKeychain() else {
            print("Access Token not found.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Host": "port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app"
        ]
        
        // 해당 일기의 id 값으로 세부 정보 받기 위한 메서드
        AF.request("https://port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app/api/v1/diaries/\(diaryId)", method: .get, headers: headers).responseDecodable(of: DiaryIdResponse.self) { response in
            switch response.result {
            case .success(let diaryIdResponse):
                if diaryIdResponse.code == "0000" {
                    print("Diary load success")
                    self.sendDiaryDataToViewController(diary: diaryIdResponse.data)
                } else {
                    print("Diary load failed: \(diaryIdResponse.message)")
                }
            case .failure(let error):
                print("Diary load error: \(error)")
            }
        }
        
        // 수정을 위한 일기 작성 화면 띄우기
        let diarysendStoryboard = UIStoryboard(name: "DiarySend", bundle: nil)
        let diarysendVC = diarysendStoryboard.instantiateViewController(identifier: "DiarySendNameViewController")
        diarysendVC.modalPresentationStyle = .fullScreen
        self.present(diarysendVC, animated: true, completion: nil)
    }
    
    // ❓
    func sendDiaryDataToViewController(diary: DiaryIdResponse.Data) {
        // 이름 수정
        NotificationCenter.default.post(name: NSNotification.Name("diaryEdit"), object: nil, userInfo: ["diary": diary])
        
        // 제목, 날짜, 내용 수정
        NotificationCenter.default.post(name: NSNotification.Name("diaryEditClicked"), object: nil)
    }
    
    
    
    
    
    //MARK: - 다이어리 삭제 버튼 탭 메서드
    @IBAction func diaryDeleteButtonTapped(_ sender: Any) {
        deleteDiary()
    }

    // 다이어리 삭제 요첨 메서드
    func deleteDiary() {
        guard let diaryId = diaryId else { return }
        
        guard let accessToken = getAccessTokenFromKeychain() else {
            print("Access Token not found.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Host": "port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app"
        ]
        
        AF.request("https://port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app/api/v1/diaries/\(diaryId)", method: .delete, headers: headers).responseDecodable(of: DeleteDiaryResponse.self) { response in
            switch response.result {
            case .success(let deleteDiaryResponse):
                if deleteDiaryResponse.code == "0000" {
                    print("Diary delete success")
                    // 성공 시, DiaryReviseViewController 닫기
                    self.dismiss(animated: true) {
                        // 성공 시, NotificationCenter를 통해 알림 보내기
                        NotificationCenter.default.post(name: NSNotification.Name("diaryDeleted"), object: nil)
                    }
                } else {
                    print("Diary delete failed: \(deleteDiaryResponse.message)")
                    // 실패 시
                }
            case .failure(let error):
                print("Diary delete error: \(error)")
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
