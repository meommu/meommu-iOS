//
//  MyPageViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/16.
//

import UIKit

class MyPageViewController: UIViewController {
    
    var pageArray: [Page] = [Page(pageName: "계정 관리"), Page(pageName: "공지")]
    
    @IBOutlet weak var pageTableView: UITableView!
    @IBOutlet weak var mainImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // 테이블 뷰 셋업 메서드
    func setupTableView() {
        // 델리게이트 패턴의 대리자 설정
        pageTableView.dataSource = self
        // 셀의 높이 설정
        pageTableView.rowHeight = 54
        
        // 셀 라인 없애기
        pageTableView.separatorStyle = .none
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
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}
