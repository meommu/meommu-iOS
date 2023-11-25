//
//  PasswordRecoveryFourthViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/11/26.
//

import UIKit

class PasswordRecoveryFourthViewController: UIViewController {

    // 버튼 프로퍼티
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //MARK: - 이전 화면 버튼
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}
