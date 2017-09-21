//
//  UIViewController+Convenience.swift
//  QOT
//
//  Created by Moucheg Mouradian on 07/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func startObservingKeyboard() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillDisappear(notification:)), name: .UIKeyboardWillHide, object: nil)
    }

    func stopObservingKeyboard() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWillAppear(notification: NSNotification) {
        fatalError("keyboardWillAppear: must be overriden")
    }

    @objc func keyboardWillDisappear(notification: NSNotification) {
        fatalError("keyboardWillDisappear: must be overriden")
    }

    func pushToStart(childViewController: UIViewController) {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.tintColor = .white
        navigationBar?.topItem?.title = ""
        navigationBar?.backIndicatorImage = R.image.ic_back()
        navigationBar?.backIndicatorTransitionMaskImage = R.image.ic_back()
        navigationBar?.titleTextAttributes = [.font: Font.H4Headline, .foregroundColor: UIColor.white]
        navigationController?.pushViewController(childViewController, animated: true)
    }
}
