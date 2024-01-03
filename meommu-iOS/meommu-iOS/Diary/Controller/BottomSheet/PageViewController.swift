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
        return pageVCArray.firstIndex(of: vc) ?? 0
    }
    
    // 부모 뷰에 삽입할 pageViewController 리스트
    var pageVCArray: [UIViewController] = []
    
    // 자식 뷰컨의 로직에 따라 바뀌는 페이지 인덱스를 저장할 프로퍼티
    var vcIndexArray: [Int] = []
    
    var guideDataArray: [GPTGuide] = []
    
    //MARK: - viewDidLoad 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageVC()
        
        makeStepTwoVC()
    }
    
    //MARK: - pageViewController 셋업 메서드
    private func setupPageVC() {
        self.dataSource = self
        self.delegate = self
        
        // 스텝 1 페이지 배열에 추가
        if let stepOneVC = UIStoryboard(name: "DiaryGuide", bundle: nil).instantiateViewController(withIdentifier: "StepOneViewController") as? StepOneViewController {
            stepOneVC.delegate = self

            fetchGPTDiaryGudie(stepOneVC: stepOneVC)
            
            pageVCArray.append(stepOneVC)
        }
        
        // 스텝 3 페이지 배열에 추가
//        if let stepThreeVC = UIStoryboard(name: "DiaryGuide", bundle: nil).instantiateViewController(withIdentifier: "StepThreeViewController") as? StepThreeViewController {
//
//            pageVCArray.append(stepThreeVC)
//        }
        
        // 첫 번째 페이지를 기본 페이지로 설정
        if let firstVC = pageVCArray.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    //MARK: - step1 뷰컨 gpt 다이어리 가이드 fetch 메서드
    private func fetchGPTDiaryGudie(stepOneVC: StepOneViewController) {
        GPTDiaryAPI.shared.getGPTDiaryGuide { result in
            switch result {
            case .success(let response):
                
                // pageVC에도 데이터 저장
                self.guideDataArray = response.data.guides
                
                // 받아온 데이터에서 guide를 배열에 할당 후 테이블 리로드한다.
                stepOneVC.guideDataArray = response.data.guides
                
                
                DispatchQueue.main.async {
                    // ❓데이터가 올라가고 뷰가 그려지는 순서 공부..!
                    stepOneVC.stepOneTableVlew.reloadData()
                }
                
            case .failure(let error):
                // 400~500 에러
                print("Error: \(error.message)")
            }
        }
    }
    
    //MARK: - step2 뷰컨 gpt 다이어리 디테일 가이드 fetch 메서드
    private func fetchGPTDiaryDetailGuide(index: Int, stepTwoVC: StepTwoViewController) {
        
        // 1. 뷰컨 생성
        // 2. 생성한 뷰컨에 다이어리 데이터 전달 (레이블 관련 데이터)
        // 3. 스텝 2 커스텀 뷰컨도 중가중간 생성
        // 4. 스텝 2 뷰컨의 마지막 버튼 선택에 따라 커스텀 뷰컨 삭제 or 추가
        // 4-1. 위의 방식이 별로면 미리 커스텀 뷰컨을 배열에 다 추가한 뒤 버튼에 따라 다음 페이지의 인덱스에 +1
            // but 이 방식은 이전으로 돌아갈 때도 고려해야 함. (사실 모든 상황에서 다 이걸 고려하긴 해야 된다.)

        GPTDiaryAPI.shared.getGPTDiaryDetailGuide(guideId: index) { result in
            switch result {
            case .success(let response):
                // step2 뷰컨에 디테일 데이터 전달
                stepTwoVC.guideDetailData = response.data.details
                print(stepTwoVC.guideDetailData)
                // 해당 뷰컨을 페이지 뷰컨 배열에 추가
                self.pageVCArray.append(stepTwoVC)
                print("\(index)번째 페치 스텝 2 뷰컨: \(stepTwoVC)")
                
                // 스텝 2 커스텀 뷰컨 배열에 추가
                if let vc = self.makeStepTwoCustomVC() {
                    self.pageVCArray.append(vc)
                }
                
            case .failure(let error):
                // 400~500 에러
                print("Error: \(error.message)")
            }
        }
        
        
    }
    
    //MARK: - 스텝 2 페이지를 미리 만들기 위한 메서드
    private func makeStepTwoVC() {
        
        // ❓일단은 하드코딩으로 인덱스가 설정하고, 뷰컨 추가
        for n in 1...5 {

            if let stepTwoVC = UIStoryboard(name: "DiaryGuide", bundle: nil).instantiateViewController(withIdentifier: "StepTwoViewController") as? StepTwoViewController {
                fetchGPTDiaryDetailGuide(index: n, stepTwoVC: stepTwoVC)
                print("\(n)번째 스텝 2 뷰컨: \(stepTwoVC)")
            }
            
        }
        
    }
    
    //MARK: - 스텝 2 커스텀 뷰컨 생성 메서드
    private func makeStepTwoCustomVC() -> StepTwoCustomTextViewController? {
        
        if let stepTwoCustomVC = UIStoryboard(name: "DiaryGuide", bundle: nil).instantiateViewController(withIdentifier: "StepTwoCustomTextViewController") as? StepTwoCustomTextViewController {
            return stepTwoCustomVC
        }
        
        return nil
    }
    
    //MARK: - 다음 페이지의 인덱스를 받아 페이지 이동 메서드
    func setNextViewControllersFromIndex(index : Int){
        // 첫번째 뷰컨일 때 선택된 버튼에 따라 뷰컨 배열을 수정하는 로직 여기다가 추가.❓
        
        if index < 0 || index >= pageVCArray.count { return }
        
        self.setViewControllers([pageVCArray[index]], direction: .forward, animated: true, completion: nil)
        
        // 페이지 뷰컨에 저장되어 있는 currentIdex를 전달
        completeHandler?(currentIndex)
    }
    
    func setNextViewControllerFormIndex(index: Int, vcIndexArray: [Int]) {
        // ❓vcIndexArray에 따라 vcArray도 바뀌는 로직을 추가해야 한다.
        self.vcIndexArray = vcIndexArray
        
        if index < 0 || index >= pageVCArray.count { return }
        self.setViewControllers([pageVCArray[index]], direction: .forward, animated: true, completion: nil)
        
        // 페이지 뷰컨에 저장되어 있는 currentIdex를 전달
        completeHandler?(currentIndex)
    }
    
    // 이전 페이지의 인덱스를 받아 페이지 이동 메서드
    func setBeforeViewControllersFromIndex(index : Int){
        if index < 0 || index >= pageVCArray.count { return }
        self.setViewControllers([pageVCArray[index]], direction: .reverse, animated: true, completion: nil)
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
        guard let vcIndex = pageVCArray.firstIndex(of: viewController) else { return nil }
        
        // 이전 페이지 인덱스
        let prevIndex = vcIndex - 1
        
        if prevIndex < 0 { return nil }
        
        return pageVCArray[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pageVCArray.firstIndex(of: viewController) else { return nil }
        
        // 다음 페이지 인덱스
        let nextIndex = vcIndex + 1
        
        if nextIndex == pageVCArray.count { return nil }
        
        return pageVCArray[nextIndex]
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

