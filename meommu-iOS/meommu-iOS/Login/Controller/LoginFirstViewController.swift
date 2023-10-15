//
//  LoginFirstViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/09/19.
//

import UIKit

class LoginFirstViewController: UIViewController {
    
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var firstSubTitleLabel: UILabel!
    @IBOutlet weak var secondSubTitleLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var loginImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLebel()
        setupButton()
        setupCornerRadius()
        setupImageView()
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
        
        firstSubTitleLabel.textColor = Color.black.textColor
        secondSubTitleLabel.textColor = Color.black.textColor
    }
    
    func setupImageView() {
        loginImageView.image = UIImage(named: "로그인")
    }
    
    // UIWindow의 rootViewController를 변경하여 화면전환 함수
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = viewControllerToPresent
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        } else {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    @IBAction func changeWindowButtonToDiary(_ sender: Any) {
        let newStoryboard = UIStoryboard(name: "Diary", bundle: nil)
        let newViewController = newStoryboard.instantiateViewController(identifier: "DiaryViewController")
        self.changeRootViewController(newViewController)
    }
    
}
