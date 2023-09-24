//
//  DiaryWriteViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/19.
//

import UIKit
import PanModal

class DiaryWriteViewController: UIViewController {

    @IBOutlet var backButton: UIBarButtonItem!
    
    
    @IBAction func OnClick_backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBOutlet var bottomGuideButton: UIButton!
    
    @IBAction func OnClick_bottomGuidButton(_ sender: Any) {
        let vc = UIStoryboard(name: "StepOne", bundle: nil).instantiateViewController(identifier: "StepOneViewController") as! StepOneViewController
        
        presentPanModal(vc)
    }
}
