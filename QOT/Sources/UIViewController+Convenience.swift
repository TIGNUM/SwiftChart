//
//  UIViewController+Convenience.swift
//  QOT
//
//  Created by Moucheg Mouradian on 07/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import qot_dal

extension UIViewController {
    typealias keyboardAnimationParameters = (endFrameY: CGFloat, height: CGFloat, duration: TimeInterval, animationCurve: UIViewAnimationOptions)

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

    func keyboardParameters(from notification: NSNotification) -> keyboardAnimationParameters? {
        guard let userInfo = notification.userInfo else { return nil }

        let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameHeight = endFrame?.size.height ?? 0
        let endFrameY = endFrame?.origin.y ?? 0
        let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
        let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)

        return (endFrameY: endFrameY, height: endFrameHeight, duration: duration, animationCurve: animationCurve)
    }

    func pushToStart(childViewController: UIViewController, enableInteractivePop: Bool = true) {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.tintColor = .white
        navigationBar?.topItem?.title = ""
        navigationBar?.backIndicatorImage = R.image.ic_back()
        navigationBar?.backIndicatorTransitionMaskImage = R.image.ic_back()
        navigationBar?.titleTextAttributes = [.font: UIFont.H5SecondaryHeadline, .foregroundColor: UIColor.white]
        navigationController?.pushViewController(childViewController, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = enableInteractivePop
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

    func showNoInternetConnectionAlert() {
        let OK = QOTAlertAction(title: ScreenTitleService.main.localizedString(for: .ButtonTitleDone))
        QOTAlert.show(title: ScreenTitleService.main.localizedString(for: .NoInternetConnectionTitle),
                      message: ScreenTitleService.main.localizedString(for: .NoInternetConnectionMessage),
                                                                       bottomItems: [OK])
    }

    func showPDFReader(withURL url: URL, title: String, itemID: Int) {
        guard QOTReachability.init().isReachable else {
            showNoInternetConnectionAlert()
            return
        }
        trackUserEvent(.OPEN, value: itemID, valueType: .CONTENT_ITEM, action: .TAP)
        let storyboard = UIStoryboard(name: "PDFReaderViewController", bundle: nil)
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            return
        }
        guard let readerViewController = navigationController.viewControllers.first as? PDFReaderViewController else {
            return
        }
        let pdfReaderConfigurator = PDFReaderConfigurator.make(contentItemID: itemID, title: title, url: url)
        pdfReaderConfigurator(readerViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
}
