//
//  ViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/17.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var firstMainLabel: UILabel!
    @IBOutlet weak var secondMainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    @IBOutlet weak var loginImageView: UIImageView!
    
    var kindergartenName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLebel()
        setupButton()
        setupCornerRadius()
        setupImageView()
    }
    
    //MARK: - 코너 레디어스 값 설정 메서드
    func setupCornerRadius() {
        nextButton.setCornerRadius(6.0)
    }
    
    func setupButton() {
        nextButton.backgroundColor = .prilmaryA
        nextButton.setTitleColor(.white, for: .normal)
        
    }
    
    func setupLebel() {
        firstMainLabel.textColor = .gray900
        secondMainLabel.textColor = .gray900
        subLabel.textColor = .gray400
        
        if let kindergartenName {
            firstMainLabel.text = "\(kindergartenName)님,"
        }
    }
    
    func setupImageView() {
        loginImageView.image = UIImage(named: "Onboarding3")
    }
    
    
    // 회원가입 완료 후 로그인 화면으로 돌아가기
    // ❗️추후 스토리보드에 navigation Controller 추가 후, navigationController?.popToRootViewController(animated:)로 수정하기
    @IBAction func changeWindowButtonToDiary(_ sender: Any) {
        // 로그인하고 일기 화면으로 rootView 변경
        let newStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let newViewController = newStoryboard.instantiateViewController(identifier: "LoginFirstViewController")
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        
        sceneDelegate.changeRootViewController(newViewController, animated: true)
        
    }
    
    
}

