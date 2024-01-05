//
//  Delegate.swift
//  meommu-iOS
//
//  Created by zaehorang on 2024/01/03.
//


protocol BottomSheetControllerDelegate: AnyObject {
    func pageArrayDidChange()
    func pageIndexArrayDidChange(data: [Int])
}

protocol BottomSheetStepTwoCustomDelegate: AnyObject {
    func showStepTwoCustomVC(bool: Bool)
}
