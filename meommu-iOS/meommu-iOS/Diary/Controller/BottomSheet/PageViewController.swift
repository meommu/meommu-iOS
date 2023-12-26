//
//  PageViewController.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/12/23.
//

import UIKit

class PageViewController: UIPageViewController {
    
    // 해당 페이지의 인덱스를 전달하기 위함
    var completeHandler : ((Int)->())?
    
    // 부모 뷰에 삽입할 pageViewController 리스트
    lazy var vcArray: [UIViewController] = {
        return [self.vcInstance(name: "StepOneViewController"),
                self.vcInstance(name: "StepTwoViewController"),
                self.vcInstance(name: "StepTwoCustomTextViewController"),
                self.vcInstance(name: "StepThreeViewController")]
    }()
    
    // 현재 뷰컨의 인덱스 저장 프로퍼티
    var currentIndex : Int {
        guard let vc = viewControllers?.first else { return 0 }
        return vcArray.firstIndex(of: vc) ?? 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageVC()
        
    }
    
    //MARK: - pageViewController 셋업 메서드
    private func setupPageVC() {
        self.dataSource = self
        self.delegate = self
        
        // 첫 번째 페이지를 기본 페이지로 설정
        if let firstVC = vcArray.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // 뷰컨 초기화 메서드
    private func vcInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "DiaryGuide", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    // 다음 페이지의 인덱스를 받아 페이지 이동 메서드
    func setNextViewControllersFromIndex(index : Int){
        if index < 0 || index >= vcArray.count { return }
        self.setViewControllers([vcArray[index]], direction: .forward, animated: true, completion: nil)
        completeHandler?(currentIndex)
    }
    
    // 이전 페이지의 인덱스를 받아 페이지 이동 메서드
    func setBeforeViewControllersFromIndex(index : Int){
        if index < 0 || index >= vcArray.count { return }
        self.setViewControllers([vcArray[index]], direction: .reverse, animated: true, completion: nil)
        completeHandler?(currentIndex)
    }
    
}

//MARK: - PageViewController 확장
extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //페이지 이동이 끝나면 호출되는 함수
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            
            // 현재 페이지 뷰컨에서 보이는 뷰의 인덱스를 부모 뷰컨에 전달
            completeHandler?(currentIndex)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 배열에서 현재 페이지의 컨트롤러를 찾아서 해당 인덱스를 현재 인덱스로 기록
        guard let vcIndex = vcArray.firstIndex(of: viewController) else { return nil }
        
        // 이전 페이지 인덱스
        let prevIndex = vcIndex - 1
        
        // 인덱스가 0 이상이라면 그냥 놔둠
        guard prevIndex >= 0 else {
            return nil
            
            // 무한반복 시 - 1페이지에서 마지막 페이지로 가야함
            // return vcArray.last
        }
        
        // 인덱스는 vcArray.count 이상이 될 수 없음
        guard vcArray.count > prevIndex else { return nil }
        
        return vcArray[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = vcArray.firstIndex(of: viewController) else { return nil }
        
        // 다음 페이지 인덱스
        let nextIndex = vcIndex + 1
        
        guard nextIndex < vcArray.count else {
            return nil
            
            // 무한반복 시 - 마지막 페이지에서 1 페이지로 가야함
            // return vcArray.first
        }
        
        guard vcArray.count > nextIndex else { return nil }
        
        return vcArray[nextIndex]
    }
    
    
}
