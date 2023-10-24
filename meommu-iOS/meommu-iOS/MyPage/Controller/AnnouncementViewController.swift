//
//  AnnouncementViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/24.
//

import UIKit

class AnnouncementViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - 백 버튼 탭 메서드

    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
            self.navigationController?.popViewController(animated: true)
    }
    

}
