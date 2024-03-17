//
//  MyPageViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/16.
//

import UIKit

class MyPageViewController: UIViewController {
    
    // 공지사항으르 저장한 프로퍼티
    var announcementDataArray: [Announcment] = []
    
    // 유저 정보 모델 - 서버 통신을 통해 데이터 전달 받아야 함
    var userProfile: UserProfileModel?
    
    var pageArray: [Page] = Page.page
    
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var kindergartenNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var pageTableView: UITableView!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var withdrawalButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupView()
        setupProfile()
        setupTableView()
    }
    
    func setupButton() {
        logoutButton.setTitleColor(.gray300, for: .normal)
        withdrawalButton.setTitleColor(.gray300, for: .normal)
        
    }
    
    func setupView() {
        lineView.backgroundColor = .gray300
    }
    
    //MARK: - 프로필 셋업 메서드
    func setupProfile() {
        
        let userProfileService = UserProfileService()
        
//        userProfileService.getUserProfile { result in
//            switch result {
//            case .success(let result):
//
//            }
//        }
        
        
        // 유저 정보 더미 데이터 생성 ❌
        userProfile = UserProfileModel(kindergartenName: "멈무유치원", representativeName: "홍길동", phoneNumber: "010-3036-1045", email: "abcd@naver.com")
        
        kindergartenNameLabel.text = userProfile?.kindergartenName
        emailLabel.text = userProfile?.email
        
        profileView.setCornerRadius(30)
    }
    
    //MARK: - 테이블 뷰 셋업 메서드
    func setupTableView() {
        // 델리게이트 패턴의 대리자 설정
        pageTableView.dataSource = self
        pageTableView.delegate = self
        // 셀의 높이 설정
        pageTableView.rowHeight = 54
        // 셀 라인 없애기
        pageTableView.separatorStyle = .none
        pageTableView.backgroundColor = .white
    }
    
    //MARK: - 로그아웃 버튼 탭 메서드
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        presetLogoutAlert()
    }
    
    //MARK: - 로그아웃 얼럿 띄우기 메서드
    private func presetLogoutAlert() {
        // 해당 얼럿 뷰 생성
        let logoutAlert = AlertViewController(alertName: "로그아웃", alertMessage: "로그아웃 후 알림을 받을 수 없습니다.", alertMainButtonName: "로그아웃", alertBackButtonName: "이전", mainAction: logoutAlertButtonTapped)
        
        // 얼럿 띄우기
        self.present(logoutAlert, animated: true)
    }
    
    //MARK: - 로그아웃 얼럿 버튼 탭 메서드
    private func logoutAlertButtonTapped() {
        // 로그인 화면으로 이동
        self.changeRootViewToLogin()
        // 저장된 액세스 토큰 삭제
        KeyChain.shared.delete(key: KeyChain.shared.accessTokenKey)
    }
    
    //MARK: - 로그인 화면으로 루트 뷰 변경 메서드
    private func changeRootViewToLogin() {
        let newStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let newViewController = newStoryboard.instantiateViewController(identifier: "LoginFirstViewController")
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        
        sceneDelegate.changeRootViewController(newViewController, animated: true)
    }
    
    
    
    //MARK: - 회원탈퇴 버튼 탭 메서드
    @IBAction func withdrawalButtonTapped(_ sender: UIButton) {
        presentWithdrawalFirstAlert()
    }
    
    //MARK: - 회원탈퇴 첫 번째 얼럿 띄우기 메서드
    private func presentWithdrawalFirstAlert() {
        // 해당 얼럿 뷰 생성
        let withdrawalFirstAlert = AlertViewController(alertName: "회원탈퇴", alertMessage: "그 동안 작성했던 모든 일기와\n입력했던 정보들이 삭제됩니다.", alertMainButtonName: "회원탈퇴", alertBackButtonName: "이전", mainAction: withdrawalFirstAlertButtonTapped)
        
        self.present(withdrawalFirstAlert, animated: true)
    }
    
    private func withdrawalFirstAlertButtonTapped() {
        
        presentWithdrawalSecondAlert()
    }
    
    //MARK: - 회원탈퇴 첫 번째 얼럿 띄우기 메서드
    private func presentWithdrawalSecondAlert() {
        // 해당 얼럿 뷰 생성
        let withdrawalSecondAlert = AlertViewController(alertName: "정말 탈퇴할까요?", alertMessage: "이 작업은 돌이킬 수 없습니다.", alertMainButtonName: "회원탈퇴", alertBackButtonName: "이전", mainAction: withdrawalSecondAlertButtonTapped)
        
        self.present(withdrawalSecondAlert, animated: true)
    }
    
    private func withdrawalSecondAlertButtonTapped() {
        let userProfileService = UserProfileService()
        
        userProfileService.withdrawalUserProfile { response in
            switch response {
            case .success(let response):
                if response.code == "0000" {
                    // 로그인 화면으로 이동
                    self.changeRootViewToLogin()
                    // 저장된 액세스 토큰 삭제
                    KeyChain.shared.delete(key: KeyChain.shared.accessTokenKey)
                } else {
                    print(response.message!)
                }
            case .failure(_):
                print("회원탈퇴 에러 발생2")
            }
        }
    }
    
    //MARK: - 백 버튼 탭 메서드
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    // 서버에서 공지 받아와서 현재 뷰컨에 있는 배열에 데이터 저장
    func getAnnouncement(completion: @escaping () -> Void) {
        
        let announcementService = AnnouncementService()
        
        announcementService.requestAnnouncment { response in
            switch response {
            case .success(let response):
                for data in response.data.notices {
                    let notice = Announcment(title: data.title, content: data.content)
                    self.announcementDataArray.append(notice)
                }
            case .failure(_):
                print("공지사항 오류")
            }
            completion()
        }
        
    }
    
}

//MARK: - UITableViewDataSource 확장
extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PageCell", for: indexPath) as! PageCell
        
        cell.pageNameLabel.text = pageArray[indexPath.row].pageName
        cell.pageImageView.image = pageArray[indexPath.row].pageImage
        
        cell.setupUI()
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
}


//MARK: - UITableDelegate 확장
extension MyPageViewController: UITableViewDelegate {
    
    // 셀 설택 시 다음 동작 실행
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            // 세그웨이를 실행
            performSegue(withIdentifier: "toProfileEditVC", sender: indexPath)
        } else if indexPath.row == 1 {
            
            getAnnouncement {
                self.performSegue(withIdentifier: "toAnnouncementVC", sender: indexPath)
            }
        }
    }
    
    // 디테일 화면으로 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileEditVC" {
            let profileEditVC = segue.destination as! ProfileEditViewController
            
            profileEditVC.userProfile = self.userProfile
        } else if segue.identifier == "toAnnouncementVC" {
            let announcementVC = segue.destination as! AnnouncementViewController
            announcementVC.announcementDataArray = self.announcementDataArray
        }
    }
    
}


