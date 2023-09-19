//
//  DiarySendNameViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/19.
//

import UIKit

class DiarySendNameViewController: UIViewController {

    // 뒤로 가기 버튼
    @IBOutlet var backButton: UIBarButtonItem!
    
    @IBAction func OnClick_BackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 작성하기 버튼
    @IBOutlet var writeButton: UIButton!
    
    @IBAction func OnClick_WriteButton(_ sender: Any) {
        
        let diarywriteStoryboard = UIStoryboard(name: "DiaryWrite", bundle: nil)
        let diarywriteVC = diarywriteStoryboard.instantiateViewController(identifier: "DiaryWriteViewController")
        
        // segue show로 구현 필요
        diarywriteVC.modalPresentationStyle = .overFullScreen
        present(diarywriteVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    

}
