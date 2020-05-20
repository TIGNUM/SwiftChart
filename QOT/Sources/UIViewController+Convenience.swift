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
    typealias keyboardAnimationParameters = (endFrameY: CGFloat, height: CGFloat, duration: TimeInterval, animationCurve: UIView.AnimationOptions)

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func startObservingKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillAppear(notification: NSNotification) {
        fatalError("keyboardWillAppear: must be overriden")
    }

    @objc func keyboardWillDisappear(notification: NSNotification) {
        fatalError("keyboardWillDisappear: must be overriden")
    }

    func keyboardParameters(from notification: NSNotification) -> keyboardAnimationParameters? {
        guard let userInfo = notification.userInfo else { return nil }

        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameHeight = endFrame?.size.height ?? 0
        let endFrameY = endFrame?.origin.y ?? 0
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)

        return (endFrameY: endFrameY, height: endFrameHeight, duration: duration, animationCurve: animationCurve)
    }

    func pushToStart(childViewController: UIViewController, enableInteractivePop: Bool = true) {
        navigationController?.pushViewController(childViewController, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = enableInteractivePop
        navigationController?.interactivePopGestureRecognizer?.delegate = childViewController
    }

    var safeAreaInsets: UIEdgeInsets {
        return view.safeAreaInsets
    }

    func showNoInternetConnectionAlert() {
        let OK = QOTAlertAction(title: AppTextService.get(.generic_view_button_done))
        QOTAlert.show(title: AppTextService.get(.generic_alert_no_internet_title),
                      message: AppTextService.get(.generic_alert_no_internet_body),
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

extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (otherGestureRecognizer is UIScreenEdgePanGestureRecognizer)
    }
}
