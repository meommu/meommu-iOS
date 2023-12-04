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
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageVIew: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCornerRadius()
        setupButton()
        setupLebel()
        setupImageView()
    }
    
    //MARK: - 코너 레디어스 값 설정 메서드
    func setupCornerRadius() {
        nextButton.setCornerRadius(6.0)
    }
    
    func setupButton() {
        nextButton.backgroundColor = .primaryA
        nextButton.setTitleColor(.white, for: .normal)
    }
    
    func setupLebel() {
        firstMainLabel.textColor = .gray900
        secondMainLabel.textColor = .gray900
    }
    
    func setupImageView() {
        
        if let firstImageView {
            firstImageView.image = UIImage(named: "Onboarding1")
        }
        
        if let secondImageView {
            secondImageView.image = UIImage(named: "Onboarding2")
        }
        
        if let thirdImageVIew {
            thirdImageVIew.image = UIImage(named: "Onboarding3")
        }
    }
    
    
}
