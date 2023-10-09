//
//  LoginFirstViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/09/19.
//

import UIKit

class LoginFirstViewController: UIViewController {
    
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLebel()
        setupButton()
        setupCornerRadius()
    }
    

    func setupCornerRadius() {
        startButton.setCornerRadius(6.0)
        signupButton.setCornerRadius(6.0)
    }
    
    func setupButton() {
        startButton.backgroundColor = Color.purple.buttonColor
        startButton.setTitleColor(Color.white.textColor, for: .normal)
        
        signupButton.backgroundColor = Color.darkGray.buttonColor
        signupButton.setTitleColor(Color.white.textColor, for: .normal)
    }

    func setupLebel() {
        mainTitleLabel.textColor = Color.black.textColor
        mainTitleLabel.textColor = Color.black.textColor
        
        subTitleLabel.textColor = Color.black.textColor
        subTitleLabel.textColor = Color.black.textColor
    }
}
