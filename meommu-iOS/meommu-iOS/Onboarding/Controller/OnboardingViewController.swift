//
//  OnboardingViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/09/18.
//

import UIKit

class OnboardingViewController: UIViewController {

    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCornerRadius()
    }
    
    //MARK: - 코너 레디어스 값 설정 메서드
    
    func setCornerRadius() {
        
        nextButton.setCornerRadius(6.0)

    }
    

}
