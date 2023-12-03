//
//  MyPageViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/16.
//

import UIKit

class MyPageViewController: UIViewController {
    
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
        // 유저 정보 더미 데이터 생성 ❌
        userProfile = UserProfileModel(kindergartenName: "멈무유치원", representativeName: "홍길동", phoneNumber: "010-3036-1045", email: "abcd@naver.com", password: "abc123@@")
        
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
    }
    
    //MARK: - 로그아웃 버튼 메서드
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        // 해당 얼럿 뷰 생성
        let logoutAlert = AlertViewController(alertName: "로그아웃", alertMessage: "로그아웃 후 알림을 받을 수 없습니다.", alertMainButtonName: "로그아웃", alertBackButtonName: "이전", mainAction: { print("로그아웃 버튼 눌림")})
        
        self.present(logoutAlert, animated: true)
    }
    
    //MARK: - 회원탈퇴 버튼 메서드
    @IBAction func withdrawalButtonTapped(_ sender: UIButton) {
        // 해당 얼럿 뷰 생성
        let withdrawalAlert = AlertViewController(alertName: "회원탈퇴", alertMessage: "그 동안 작성했던 모든 일기와\n입력했던 정보들이 삭제됩니다.", alertMainButtonName: "회원탈퇴", alertBackButtonName: "이전", mainAction: { print("회원탈퇴 버튼 눌림")})
        
        self.present(withdrawalAlert, animated: true)
    }
    
    //MARK: - 백 버튼 탭 메서드
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
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
            performSegue(withIdentifier: "toAnnouncementVC", sender: indexPath)
        }
    }
    
    // 디테일 화면으로 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileEditVC" {
            let profileEditVC = segue.destination as! ProfileEditViewController
//            let index = sender as! IndexPath
            
            profileEditVC.userProfile = self.userProfile
        }
    }
}


