//
//  ViewController.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/17.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // 화면 전환
    @IBOutlet var loginButton: UIButton!

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
    
    // Diary 화면으로 전환
    @IBAction func changeWindowButtonToDiary(_ sender: Any) {
        let newStoryboard = UIStoryboard(name: "Diary", bundle: nil)
        let newViewController = newStoryboard.instantiateViewController(identifier: "DiaryViewController")
        self.changeRootViewController(newViewController)
    }
    
}

