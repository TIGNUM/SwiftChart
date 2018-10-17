//
//  UIViewController+Convenience.swift
//  QOT
//
//  Created by Moucheg Mouradian on 07/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func startObservingKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: .UIKeyboardWillHide, object: nil)
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
        navigationBar?.titleTextAttributes = [.font: UIFont.H5SecondaryHeadline, .foregroundColor: UIColor.white]
        navigationController?.pushViewController(childViewController, animated: true)
    }

    /**
     Sets `contentInset` on `scrollView` with consideration for `UINavigationController` and `UITabBarController`.
     - note: This is meant to be the *one method to rule them all* for setting up a scrollView such a `UITableView` with
     `contentInsets` taking account of any nav / tab bars. This method should be called in:
     1. viewDidLayoutSubviews()
     2. viewSafeAreaInsetsDidChange()
    */
    func configureContentInset(inset: UIEdgeInsets, scrollView: UIScrollView) {
        automaticallyAdjustsScrollViewInsets = false

        let safeArea: UIEdgeInsets
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
            safeArea = view.safeAreaInsets
        } else {
            let top = topLayoutGuide.length
            let bottom = bottomLayoutGuide.length
            safeArea = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
        }

        var newInset = inset
        newInset.bottom += safeArea.bottom
        newInset.top += safeArea.top
        newInset.left += safeArea.left
        newInset.right += safeArea.right

        let currentInset = scrollView.contentInset
        if currentInset != newInset {
            let currentOffest = scrollView.contentOffset
            let newOffest = CGPoint(x: currentOffest.x - (newInset.left - currentInset.left),
                                    y: currentOffest.y - (newInset.top - currentInset.top))
            scrollView.contentInset = newInset
            scrollView.contentOffset = newOffest
        }
    }

    var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        } else {
            let top = topLayoutGuide.length
            let bottom = bottomLayoutGuide.length
            return UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
        }
    }
}
