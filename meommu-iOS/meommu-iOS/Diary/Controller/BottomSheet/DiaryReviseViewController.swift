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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // 일기 수정하기
    
    @IBOutlet var diaryEditButton: UIButton!
    
    @IBAction func OnClick_diaryEditButton(_ sender: Any) {
        guard let diaryId = diaryId else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AccessToken)",
            "Host": "port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app"
        ]
        
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
        
        let diarysendStoryboard = UIStoryboard(name: "DiarySend", bundle: nil)
        let diarysendVC = diarysendStoryboard.instantiateViewController(identifier: "DiarySendNameViewController")
        diarysendVC.modalPresentationStyle = .fullScreen
        self.present(diarysendVC, animated: true, completion: nil)
    }
    
    func sendDiaryDataToViewController(diary: DiaryIdResponse.Data) {
        // 이름 수정
        NotificationCenter.default.post(name: NSNotification.Name("diaryEdit"), object: nil, userInfo: ["diary": diary])
        
        // 제목, 날짜, 내용 수정
        NotificationCenter.default.post(name: NSNotification.Name("diaryEditClicked"), object: nil)
    }
    
    // 일기 삭제하기
    var diaryId: Int?
    
    
    @IBOutlet var diaryDeleteButton: UIButton!
    
    @IBAction func OnClick_diaryDeleteButton(_ sender: Any) {
        deleteDiary()
    }
    
    let AccessToken = "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6NiwiaWF0IjoxNzAxMDAxMjUwLCJleHAiOjE3MDE2MDYwNTB9.d8HZ_LrgFNxBNPmdXBBxw3c7OvoEdukOYxP-Kqepkz6IFn8jiNvrGjEjFhm37UWtX6a3Qeb2YYVFMIdBsHC9FA"
    
    func deleteDiary() {
        guard let diaryId = diaryId else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AccessToken)",
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
