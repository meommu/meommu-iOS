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
    }
    
    // -----------------------------------------
    // 일기 수정 및 삭제 바텀시트 생성하기
    @IBOutlet var diaryReviseButton: UIBarButtonItem!
    
    @IBAction func OnClick_diaryRiviseButton(_ sender: Any) {
        let vc = UIStoryboard(name: "DiaryRevise", bundle: nil).instantiateViewController(identifier: "DiaryReviseViewController") as! DiaryReviseViewController
        
        presentPanModal(vc)
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
    
    var Image: String?
    var Title: String?
    var Detail: String?
    var Date: String?
    var Name: String?
    
    func updateUI(){
        if let Image = self.Image, let Title = self.Title, let Detail = self.Detail, let Date = self.Date {
            
            diaryImageView.image = UIImage(named: Image)
            diaryTitle.text = Title
            diaryDetail.text = Detail
            diaryDate.text = Date
            diaryName.text = Name
        }
    }
    

}
