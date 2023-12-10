//
//  AnnouncementViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/10/24.
//

import UIKit

class AnnouncementViewController: UIViewController {
    
    var announcementDataArray: [Announcment] = []
    
    @IBOutlet weak var announcementTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDelegate()
        setupTableView()
        

    }
    
    private func setupTableView() {
        // 테이블뷰 라인 없애기
        announcementTableView.separatorStyle = .none
    }
    
    func setupDelegate() {
        announcementTableView.dataSource = self
        announcementTableView.delegate = self
    }
    
    //MARK: - 백 버튼 탭 메서드

    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
            self.navigationController?.popViewController(animated: true)
    }
    
}

extension AnnouncementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        announcementDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementTableViewCell", for: indexPath) as! AnnouncementTableViewCell
        let announcement = announcementDataArray[indexPath.row]
        cell.prepareCellData(announcment: announcement)
        cell.setupCell()
        
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension AnnouncementViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        announcementDataArray[indexPath.row].isContentHidden.toggle()
        tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: UITableView.RowAnimation.automatic)
        }
    
   
}


