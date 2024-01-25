//
//  DiaryGuideWirtePageViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/12/16.
//

import UIKit
import PanModal

class DiaryGuideWirtePageViewController: UIViewController {
    
    // 컨테이너 뷰에서 보이는 화면의 인덱스 값을 저장하기 위한 프로퍼티
    var currentIndex = 0
    
    var pageViewController : PageViewController!
    
    // 유저가 선택한 가이드 데이터
    var guideDatas: [String] = []
    
    // 유저의 가이드 데이터 대리자
    var writeVCDelegate: WirteVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //MARK: - 버튼 선택 메서드
    @IBAction func nextButtonTapped(_ sender: Any) {
        // 다음 페이지로 이동
        pageViewController.setNextViewControllersFromIndex(index: currentIndex)
    }
    
    
    @IBAction func beforeButtonTapped(_ sender: Any) {
        // 이전 페이지로 이동
        pageViewController.setBeforeViewControllersFromIndex(index: currentIndex)
    }
    
    
    //MARK: - 세그웨이의 prepare 메서드를 통해 데이터 교환
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(currentIndex)
            if segue.identifier == "PageViewController" {
                print("Connected")
                
                // 세그웨이의 도착지인 pageVC를 현재 부모 뷰컨에 저장
                guard let vc = segue.destination as? PageViewController else { return }
                pageViewController = vc
                
                // 페이지 뷰컨의 뷰 인덱스를 해당 뷰컨에 할당한다.
                pageViewController.completeHandler = { (result) in
                    self.currentIndex = result
                }
                
                // step3에서 다음을 누르면 자신을 해제시키는 기능 할당
                pageViewController.dismissBottomSheet = {
                    
                    // 가이드 데이터 전달
                    self.writeVCDelegate?.getGuideData(self.guideDatas)
  
                    self.writeVCDelegate?.sseEventStart()
                    
                    // VC 해제한다.
                    self.dismiss(animated: true)
                    print("dismisss완료")
                }
                
                
                pageViewController.guideDatasCompletHanelder = { (result) in
                    // 컨테이너 VC에게 데이터를 받는다.
                    self.guideDatas = result
                    print("데이터 전달 완료")
                }
                
            }
            
        }
    
    
}

//MARK: - PanModalPresentable 확장 코드
extension DiaryGuideWirtePageViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    // 짧은 형태의 높이 설정
    var shortFormHeight: PanModalHeight {
        return .contentHeight(510)  // 바텀 시트의 높이 설정
    }
    
    // 상단 코너를 둥글게 설정
    var shouldRoundTopCorners: Bool {
        return true
    }
    
    // 상단 코너의 반경을 설정
    var cornerRadius: CGFloat {
        return 20.0  // 둥근 모서리 설정
    }
    
    // 최상단 스크롤 불가
    var anchorModalToLongForm: Bool {
        return false
    }
}
