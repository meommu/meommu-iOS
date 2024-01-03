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
    
    // 현재 뷰컨의 인덱스 저장 프로퍼티
    var currentIndex : Int {
        guard let vc = viewControllers?.first else { return 0 }
        return vcArray.firstIndex(of: vc) ?? 0
    }
    
    

    // 부모 뷰에 삽입할 pageViewController 리스트
    var vcArray: [UIViewController] = []
    
    // 자식 뷰컨의 로직에 따라 바뀌는 페이지 인덱스를 저장할 프로퍼티
    var vcIndexArray: [Int] = []
    
    
    //MARK: - viewDidLoad 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageVC()
    }
    
    //MARK: - pageViewController 셋업 메서드
    private func setupPageVC() {
        self.dataSource = self
        self.delegate = self
        
        // 스텝 1 페이지 배열에 추가
        if let stepOneVC = UIStoryboard(name: "DiaryGuide", bundle: nil).instantiateViewController(withIdentifier: "StepOneViewController") as? StepOneViewController {
            stepOneVC.delegate = self

            vcArray.append(stepOneVC)
        }
        
        // 스텝 3 페이지 배열에 추가
        if let stepThreeVC = UIStoryboard(name: "DiaryGuide", bundle: nil).instantiateViewController(withIdentifier: "StepThreeViewController") as? StepThreeViewController {

            vcArray.append(stepThreeVC)
        }
        
        // 첫 번째 페이지를 기본 페이지로 설정
        if let firstVC = vcArray.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    //MARK: - 스텝 2 페이지를 미리 만들기 위한 메서드
    private func setupStepTwoVC() {
        
    }
    
    //MARK: - 다음 페이지의 인덱스를 받아 페이지 이동 메서드
    func setNextViewControllersFromIndex(index : Int){
        // 첫번째 뷰컨일 때 선택된 버튼에 따라 뷰컨 배열을 수정하는 로직 여기다가 추가.❓
        
        if index < 0 || index >= vcArray.count { return }
        self.setViewControllers([vcArray[index]], direction: .forward, animated: true, completion: nil)
        
        // 페이지 뷰컨에 저장되어 있는 currentIdex를 전달
        completeHandler?(currentIndex)
    }
    
    func setNextViewControllerFormIndex(index: Int, vcIndexArray: [Int]) {
        // ❓vcIndexArray에 따라 vcArray도 바뀌는 로직을 추가해야 한다.
        self.vcIndexArray = vcIndexArray
        
        if index < 0 || index >= vcArray.count { return }
        self.setViewControllers([vcArray[index]], direction: .forward, animated: true, completion: nil)
        
        // 페이지 뷰컨에 저장되어 있는 currentIdex를 전달
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
            
            // pageVC에서 현재 보이는 뷰의 인덱스를 부모 뷰컨에 전달
            completeHandler?(currentIndex)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 배열에서 현재 페이지의 컨트롤러를 찾아서 해당 인덱스를 현재 인덱스로 기록
        guard let vcIndex = vcArray.firstIndex(of: viewController) else { return nil }
        
        // 이전 페이지 인덱스
        let prevIndex = vcIndex - 1
        
        if prevIndex < 0 { return nil }
        
        return vcArray[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = vcArray.firstIndex(of: viewController) else { return nil }
        
        // 다음 페이지 인덱스
        let nextIndex = vcIndex + 1
        
        if nextIndex == vcArray.count { return nil }
        
        return vcArray[nextIndex]
    }
}

//MARK: - BottomSheetControllerDelegate
// 가이트 시트에서 선택된 버튼의 인덱스 배열을 저장하기 위해 델리게이트 패턴 채택
extension PageViewController: BottomSheetControllerDelegate {
    
    func pageArrayDidChange(data: [Int]) {
        self.vcIndexArray = data
        print("페이지 뷰컨: \(self.vcIndexArray)")
    }
    
}
