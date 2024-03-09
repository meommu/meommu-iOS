//
//  ToastManager.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/12/01.
//

import UIKit

class ToastManager {
    // 텍스트 필드 아래로 토스트 얼럿 띄우기
    // textFieldBottomMargin: 텍스트 필드 bottom과 토스트 얼럿 top의 distance
    // ❗️ 추후 특정 텍스트 필드가 아닌 모든 UIView 관련 프로퍼티에 적용 가능하게 추상화 진행
    
    static func showToastBelowTextField(message: String, font: UIFont, belowTextField textField: UITextField, textFieldBottomMargin: CGFloat, in viewController: UIViewController) {
        let toastLabel = PaddingToastLabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.backgroundColor = UIColor.gray400
        toastLabel.textColor = UIColor.gray200
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        viewController.view.addSubview(toastLabel)

        // 오토레이아웃 설정
        NSLayoutConstraint.activate([
            toastLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: textFieldBottomMargin),
            toastLabel.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
            toastLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    // 텍스트 필드 위로 토스트 얼럿 띄우기
    // textFieldTopMargin: 텍스트 필드 top과 토스트 얼럿 bottom의 distance
    static func showToastAboveTextField(message: String, font: UIFont, aboveTextField textField: UITextField, textFieldTopMargin: CGFloat, in viewController: UIViewController) {
        let toastLabel = PaddingToastLabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.backgroundColor = UIColor.gray400
        toastLabel.textColor = UIColor.gray200
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        viewController.view.addSubview(toastLabel)
        
        // 오토레이아웃 설정
        NSLayoutConstraint.activate([
            toastLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -textFieldTopMargin),
            toastLabel.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
            toastLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    static func showToastAboveButton(message: String, font: UIFont, aboveUIButton button: UIButton, UIButtonTopMargin: CGFloat, in viewController: UIViewController) {
        let toastLabel = PaddingToastLabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.backgroundColor = UIColor.gray400
        toastLabel.textColor = UIColor.gray200
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        viewController.view.addSubview(toastLabel)
        
        // 오토레이아웃 설정
        NSLayoutConstraint.activate([
            toastLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: UIButtonTopMargin),
            toastLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            toastLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    
}

// 토스트 레이블에 패딩 값을 넣어주기 위함.
final class PaddingToastLabel: UILabel {
    private var padding = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}
