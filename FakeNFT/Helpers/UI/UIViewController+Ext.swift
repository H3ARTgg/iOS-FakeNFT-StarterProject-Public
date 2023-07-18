//
//  UIViewController+Ext.swift
//  FakeNFT
//
//  Created by Aleksandr Velikanov on 28.06.2023.
//

import UIKit
import ProgressHUD

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Presentable

protocol Presentable: AnyObject {
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
}

// MARK: - Progress HUD

extension UIViewController {
    func displayLoading(_ isVisible: Bool) {
        if isVisible {
            ProgressHUD.show()
        } else {
            ProgressHUD.dismiss()
        }
    }
}

// MARK: - Error UI
extension UIViewController {
    func setupErrorContent(with tuple: (UILabel, OtherCustomButton)) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            tuple.0.text = "Error"
            tuple.0.font = Consts.Fonts.regular17
            tuple.0.textColor = Asset.Colors.ypBlack.color
            
            tuple.1.setImage(nil, for: .normal)
            
            [tuple.0, tuple.1].forEach {
                self.view.addSubview($0)
            }
            
            tuple.0.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
            tuple.1.snp.makeConstraints { make in
                make.top.equalTo(tuple.0.snp.bottom).offset(10)
                make.leading.equalTo(self.view.snp.leading).offset(60)
                make.trailing.equalTo(self.view.snp.trailing).offset(-60)
                make.height.equalTo(35)
            }
        }
    }
}
