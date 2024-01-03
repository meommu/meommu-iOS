//
//  Delegate.swift
//  meommu-iOS
//
//  Created by zaehorang on 2024/01/03.
//


protocol BottomSheetControllerDelegate: AnyObject {
    func pageArrayDidChange(data: [Int])
}
