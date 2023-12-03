//
//  ToastManager.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/12/01.
//

import UIKit

class ToastManager {
    static func showToastBelowTextField(message: String, font: UIFont, belowTextField textField: UITextField, in viewController: UIViewController) {
        let toastLabel = UILabel()
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
            toastLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 7),
            toastLabel.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
            toastLabel.widthAnchor.constraint(equalToConstant: 208),
            toastLabel.heightAnchor.constraint(equalToConstant: 45)
        ])

        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    static func showToastAboveTextField(message: String, font: UIFont, aboveTextField textField: UITextField, in viewController: UIViewController) {
            let toastLabel = UILabel()
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
                toastLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -13),
                toastLabel.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
                toastLabel.widthAnchor.constraint(equalToConstant: 177),
                toastLabel.heightAnchor.constraint(equalToConstant: 45)
            ])

            UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: { (isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    
    
}
