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
        setupText()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            print(1)
            
            self?.alertView.transform = .identity
            self?.alertView.isHidden = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.alertView.transform = .identity
            self?.alertView.isHidden = true
        }
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
    
    private func setupText() {
        titleLabel.text = alertName
        messageLabel.text = alertMessage
        
        mainButton.setTitle(alertMainButtonName, for: .normal)
        backButton.setTitle(alertBackButtonName, for: .normal)
    }
    
    private func setupView() {
        // 팝업이 등장할 때(viewWillAppear)에서 containerView.transform = .identity로 하여 애니메이션 효과 주는 용도
        self.alertView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        alertView.backgroundColor = .black
        alertView.layer.masksToBounds = true
        alertView.layer.cornerRadius = 20
        
        titleLabel.textColor = UIColor(hexCode: "FFFFFF")
        messageLabel.textColor = UIColor(hexCode: "ABABAB")
        
        mainButton.layer.masksToBounds = true
        mainButton.layer.cornerRadius = 6
        mainButton.backgroundColor = UIColor(hexCode: "CCCCD9")
        mainButton.setTitleColor(UIColor(hexCode: "565667"), for: .normal)
        
        backButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = 6
        backButton.backgroundColor = UIColor(hexCode: "8579F1")
        backButton.setTitleColor(UIColor(hexCode: "FFFFFF"), for: .normal)
    }
    
    
    // 메인 버튼 탭 액션
    @IBAction func mainButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: false)
        mainAction?()
    }
    
    // 얼럿 창 없애기
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}


