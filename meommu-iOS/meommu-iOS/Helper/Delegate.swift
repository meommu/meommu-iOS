//
//  Delegate.swift
//  meommu-iOS
//
//  Created by zaehorang on 2024/01/03.
//


//MARK: - step2을 보여주기 위한 프로토콜 정의
protocol BottomSheetControllerDelegate: AnyObject {
    func pageArrayDidChange()
    func pageIndexArrayDidChange(data: [Int])
}

//MARK: - step2-1 VC의 유무를 다루는 프로토콜 정의
protocol BottomSheetStepTwoCustomDelegate: AnyObject {
    func showStepTwoCustomVC(bool: Bool)
}

//MARK: - 데이터 전송을 다루는 프로토콜 정의
protocol BottomSheetDataDelegate: AnyObject {
    func saveData(_ data: String)
    func removeData(_ data: String)
}
