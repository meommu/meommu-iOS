//
//  OnboardingViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/09/18.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var firstMainLabel: UILabel!
    @IBOutlet weak var secondMainLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCornerRadius()
        setupButton()
        setupLebel()
    }
    
    //MARK: - 코너 레디어스 값 설정 메서드
    func setupCornerRadius() {
        nextButton.setCornerRadius(6.0)
    }
    
    func setupButton() {
        nextButton.backgroundColor = Color.purple.buttonColor
        nextButton.setTitleColor(Color.white.textColor, for: .normal)
    }

    func setupLebel() {
        firstMainLabel.textColor = Color.black.textColor
        secondMainLabel.textColor = Color.black.textColor
    }
}
