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
    
    // 초기에 모든 뷰 컨트롤러들을 저장할 배열
    var allPageVCArray: [UIViewController] = []
    
    // 자식 뷰컨의 로직에 따라 바뀌는 페이지 인덱스를 저장할 프로퍼티
    var stepTwoVCIndexArray: [Int] = []
    
    var guideDataArray: [GPTGuide] = []
    
    //MARK: - viewDidLoad 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageVC()
        updatePageVCArray()
    }
    
    //MARK: - 페이지 인덱스 배열에 따라 페이지를 조정하는 메서드
    func updatePageVCArray() {
        print("스텝 2 인덱스 배열:\(stepTwoVCIndexArray)")
        // 페이지 배열 전체 삭제
        self.pageVCArray.removeAll()
        
        // 첫 번째 페이지 추가
        self.pageVCArray.append(allPageVCArray[0])
        
        for index in stepTwoVCIndexArray {
            
            switch index {
            case 1:
                self.pageVCArray.append(allPageVCArray[1])
            case 2:
                self.pageVCArray.append(allPageVCArray[2])
            case 3:
                self.pageVCArray.append(allPageVCArray[3])
            case 4:
                self.pageVCArray.append(allPageVCArray[4])
            case 5:
                self.pageVCArray.append(allPageVCArray[5])
            default:
                break
            }
        }
        
        // 마지막 페이지 추가
        self.pageVCArray.append(allPageVCArray[allPageVCArray.count - 1])
        
    }
    
    //MARK: - pageViewController 셋업 메서드
    private func setupPageVC() {
        print(#function)
        // pageViewController 관련 델리게이트 선언
        self.dataSource = self
        self.delegate = self
        
        // step1, 2, 3 vc 생성
        makeStepOneVC(completion: makeStepTwoAndThreeVC)
        
        // 첫 번째 페이지를 기본 페이지로 설정
        if let firstVC = pageVCArray.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    
    //MARK: - 스텝 1 VC 만들기 메서드
    private func makeStepOneVC(completion: @escaping () -> ()) {
        print(#function)
        // 스텝 1 페이지 배열에 추가
        if let stepOneVC = UIStoryboard(name: "DiaryGuide", bundle: nil).instantiateViewController(withIdentifier: "StepOneViewController") as? StepOneViewController {
            
            // 스텝 1 VC를 페이지 배열에 추가
            allPageVCArray.append(stepOneVC)
            pageVCArray.append(stepOneVC)
            
            // 스텝 1 vc 델리게이트 설정
            stepOneVC.pageVCDelegate = self
            
            // 스텝 1 페이지 관련 데이터 fetch
            fetchGPTDiaryGudie(stepOneVC: stepOneVC, completion: completion)
            
            
        }
        
    }
    
    //MARK: - step1 뷰컨 gpt 다이어리 가이드 fetch 메서드
    private func fetchGPTDiaryGudie(stepOneVC: StepOneViewController, completion:  @escaping () -> ()) {
        print(#function)
        GPTDiaryAPI.shared.getGPTDiaryGuide { result in
            switch result {
            case .success(let response):
                
                // pageVC에도 데이터 저장
                self.guideDataArray = response.data.guides
                
                // 받아온 데이터에서 guide를 배열에 할당 후 테이블 리로드한다.
                stepOneVC.guideDataArray = response.data.guides
                
                DispatchQueue.main.async {
                    stepOneVC.stepOneTableVlew.reloadData()
                }
                
                // 데이터가 다 만들어 진 뒤 스텝 2 만들기 시작
                print("스텝 1 만들고 2 만들기 시작")
                completion()
                
            case .failure(let error):
                // 400~500 에러
                print("Error: \(error.message)")
            }
        }
    }
    
    //MARK: - 스텝 2 VC 만들기 메서드
    private func makeStepTwoAndThreeVC()  {
        print(#function)
        for index in 1...5 {
            if let stepTwoVC = UIStoryboard(name: "DiaryGuide", bundle: nil).instantiateViewController(withIdentifier: "StepTwoViewController") as? StepTwoViewController {
                print("\(index)번째 스텝 2 만들기")
                // 비동기 함수 처리 전 순서 보장을 위해 배열에 스텝2 VC 미리 저장
                self.allPageVCArray.append(stepTwoVC)
                
                fetchGPTDiaryDetailGuide(index: index, stepTwoVC: stepTwoVC)
            }
        }
        
        // step3 vc 생성
        makeStepThreeVC()
        
    }
    
    //MARK: - step2 뷰컨 gpt 다이어리 디테일 가이드 fetch 메서드
    private func fetchGPTDiaryDetailGuide(index: Int, stepTwoVC: StepTwoViewController) {
        
        GPTDiaryAPI.shared.getGPTDiaryDetailGuide(guideId: index) { result in
            switch result {
            case .success(let response):
                // step2 뷰컨에 디테일 데이터 전달
                stepTwoVC.guideDetailData = response.data.details
                
                // step1에서 비동기적으로 받은 데이터를 pageVC에 저장하고 step2에 전달하는 코드
                stepTwoVC.guideData = self.guideDataArray[index - 1]
                
                // step2 델리게이트 설정
                stepTwoVC.customVCDeldgate = self
                
            case .failure(let error):
                // 400~500 에러
                print("Error: \(error.message)")
            }
        }
        
        
    }
    
    //MARK: - 스텝 2 커스텀 뷰컨 생성 메서드
    private func makeStepTwoCustomVC() -> UIViewController? {
        
        let stepTwoCustomVC = UIStoryboard(name: "DiaryGuide", bundle: nil).instantiateViewController(withIdentifier: "StepTwoCustomTextViewController")
        
        return stepTwoCustomVC
    }
    
    //MARK: - 스텝 3 뷰컨 생성 메서드
    private func makeStepThreeVC() {
        print(#function)
        if let stepThreeVC = UIStoryboard(name: "DiaryGuide", bundle: nil).instantiateViewController(withIdentifier: "StepThreeViewController") as? StepThreeViewController {
            
            // step3 vc를 페이지 배열에 추가
            self.allPageVCArray.append(stepThreeVC)
            
        }
        
    }
    //MARK: - 현재 페이지의 인덱스를 받아 페이지 이동 메서드
    // index 파라미터: 현재 페이지
    func setNextViewControllersFromIndex(index : Int){
        print("넥 페이지 배열: \(pageVCArray)")
        print("넥 전체페이지 배열: \(allPageVCArray)")
        // 가능한 인덱스 범위 설정
        guard index >= 0 && index < pageVCArray.count - 1 else { return }
        
        // 다음 인덱스 번호를 보여줘야 하기 때문에 + 1
        self.setViewControllers([pageVCArray[index + 1]], direction: .forward, animated: true, completion: nil)
        
        print("넥 presnt: \(currentIndex)")
        
        // 페이지 뷰컨에 저장되어 있는 currentIdex를 전달
        completeHandler?(currentIndex)
    }
    
    func setBeforeViewControllersFromIndex(index : Int){
        print("비 페이지 배열: \(pageVCArray)")
        print("비 전체페이지 배열: \(allPageVCArray)")
        // 가능한 인덱스 범위 설정
        guard index > 0 && index < pageVCArray.count  else { return }
        
        // 이전 인덱스 번호를 보여줘야 하기 때문에 - 1
        self.setViewControllers([pageVCArray[index - 1]], direction: .reverse, animated: true, completion: nil)
        
        print("비 presnt: \(currentIndex)")
        
        // 페이지 뷰컨에 저장되어 있는 currentIdex를 전달
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
    
    // 저장된 인덱스 배열에 따라 step2 페이지 갱신
    func pageArrayDidChange() {
        self.updatePageVCArray()
    }
    
    // 선택된 셀의 인덱스 배열을 해당 뷰컨에 저장
    func pageIndexArrayDidChange(data: [Int]) {
        self.stepTwoVCIndexArray = data
        print("페이지 뷰컨: \(self.stepTwoVCIndexArray)")
    }
    
}

extension PageViewController: BottomSheetStepTwoCustomDelegate {
    func showStepTwoCustomVC(bool: Bool) {
        if bool {
            if let stepTwoCustomVC = makeStepTwoCustomVC() {
                self.pageVCArray.insert(stepTwoCustomVC, at: currentIndex + 1)
            }
        } else {
            self.pageVCArray.remove(at: currentIndex + 1)
        }
        // 커스텀 셀이 선택되면 현재 인덱스 다음 순번에 뷰컨 추가
        // 선택 취소되면 현재 인덱스 다음 순번 뷰컨 삭제
        // 뷰컨이 추가된 뒤에만 삭제 로직이 진행되어야 한다.
    }
}
