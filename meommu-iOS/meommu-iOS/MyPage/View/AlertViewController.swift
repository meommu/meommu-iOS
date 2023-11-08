//
//  AlertViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/11/07.
//

import UIKit

class AlertViewController: UIViewController {
    
    private var alertName: String?
    private var alertMessage: String?
    private var alertMainButtonName: String?
    private var alertBackButtonName: String?
    
    var mainAction: (() -> ())?
    
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var  mainButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    init() {
        super.init(nibName: "AlertViewController", bundle: Bundle(for: AlertViewController.self))
        
        // 아래 뷰가 보이기 위해서 .overFulleScreen으로 지정
        self.modalPresentationStyle = .overFullScreen
        // 팝업 창이 가운데서 뜨기 위한 스타일 설정
        self.modalTransitionStyle = .crossDissolve
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(alertName: String, alertMessage: String, alertMainButtonName: String, alertBackButtonName: String, mainAction: @escaping (() -> ())) {
        self.init()
        
        self.alertName = alertName
        self.alertMessage = alertMessage
        self.alertMainButtonName = alertMainButtonName
        self.alertBackButtonName = alertBackButtonName
        
        self.mainAction = mainAction
        
    }
    
    private func setupView() {
        titleLabel.text = alertName
        messageLabel.text = alertMessage
        
        mainButton.setTitle(alertMainButtonName, for: .normal)
        backButton.setTitle(alertBackButtonName, for: .normal)
    }
    
    
    @IBAction func mainButtonTapped(_ sender: UIButton) {
        mainAction?()
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
