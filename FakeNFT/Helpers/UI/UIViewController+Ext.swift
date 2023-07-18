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
