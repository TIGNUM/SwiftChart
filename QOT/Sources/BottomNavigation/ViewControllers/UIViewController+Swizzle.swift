//
//  UIViewController+Swizzle.swift
//  LevelNavigationDemo
//
//  Created by Sanggeon Park on 20.06.19.
//  Copyright © 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit
import AVKit

protocol ScreenZLevel {}

var viewWillAppearIsSwizzled = false
var presentViewControllerIsSwizzled = false

func swizzleUIViewController() {
    if viewWillAppearIsSwizzled == false {
        swizzleUIViewControllerViewWillAppear()
    }

    if presentViewControllerIsSwizzled == false {
        swizzleUIViewControllerPresentViewController()
    }
}

func swizzleUIViewControllerViewWillAppear() {
    let originalSelector = #selector(UIViewController.viewWillAppear(_:))
    let swizzledSelector = #selector(UIViewController.viewWillAppearSwizzled(animated:))

    let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
    let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)

    if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
        // switch implementation..
        method_exchangeImplementations(originalMethod, swizzledMethod)
        viewWillAppearIsSwizzled = !viewWillAppearIsSwizzled
    }
}

func swizzleUIViewControllerPresentViewController() {
    let originalSelector = #selector(UIViewController.present(_:animated:completion:))
    let swizzledSelector = #selector(UIViewController.presentSwizzled(viewControllerToPresent:animated:completion:))

    let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
    let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)

    if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
        // switch implementation..
        method_exchangeImplementations(originalMethod, swizzledMethod)
        presentViewControllerIsSwizzled = !presentViewControllerIsSwizzled
    }
}

extension UIViewController {

    @objc func viewWillAppearSwizzled(animated: Bool) {
        let viewControllerName = NSStringFromClass(type(of: self))
        log("swizzled viewWillAppear: \(viewControllerName)", level: .info)

        refreshBottomNavigationItems()
        setStatusBar(color: view.backgroundColor)
        self.viewWillAppearSwizzled(animated: animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }

    func setStatusBar(colorMode: ColorMode) {
        setStatusBar(color: colorMode.background)
    }

    func setStatusBar(color: UIColor?) {
        guard let statusBar = UIApplication.shared.statusBarView,
            statusBar.responds(to: #selector(setter: UIView.backgroundColor)) else {
                return
        }
        statusBar.backgroundColor = color
    }

    private func navigationNotificationBlock() -> (() -> Void)? {
        return { [weak self] in
            DispatchQueue.main.async {
                let item = BottomNavigationItem(leftBarButtonItems: self?.bottomNavigationLeftBarItems() ?? [],
                                                rightBarButtonItems: self?.bottomNavigationRightBarItems() ?? [],
                                                backgroundColor: self?.bottomNavigationBackgroundColor() ?? .clear)
                let notification = Notification(name: .updateBottomNavigation, object: item, userInfo: nil)
                NotificationCenter.default.post(notification)
            }
        }
    }

    @objc func presentSwizzled(viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if viewControllerToPresent is UIActivityViewController || viewControllerToPresent is UIAlertController {
            presentSwizzled(viewControllerToPresent: viewControllerToPresent, animated: animated, completion: completion)
            return
        }
        let viewControllerName = NSStringFromClass(type(of: viewControllerToPresent))
        log("swizzled   present: \(viewControllerName)", level: .debug)
        var vc = viewControllerToPresent
        if (vc as? UINavigationController) == nil && (viewControllerToPresent is UIAlertController) == false {
            let naviController = UINavigationController(rootViewController: vc)
            naviController.isToolbarHidden = true
            naviController.isNavigationBarHidden = true
            naviController.modalPresentationStyle = viewControllerToPresent.modalPresentationStyle
            naviController.modalTransitionStyle = viewControllerToPresent.modalTransitionStyle
            naviController.modalPresentationCapturesStatusBarAppearance = viewControllerToPresent.modalPresentationCapturesStatusBarAppearance

            vc = naviController
        }

        baseRootViewController?.navigationController?.presentModal(vc, from: self, animated: animated, completion: completion)
    }
}

extension UIViewController {

    @objc open func refreshBottomNavigationItems() {
        if (self as? UINavigationController) == nil,
            (self as? UIPageViewController) == nil,
            (self as? ScreenZLevelOverlay) == nil,
            let notificationBlock = navigationNotificationBlock() {
            notificationBlock()
        }
    }

    @objc open func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        if NSStringFromClass(type(of: self)).hasPrefix("QOT.") == false {
            return nil
        }

        switch self {
        case is ScreenZLevel1,
             is ScreenZLevelBottom:
            return nil
        default:
            if self.navigationController?.viewControllers.first == self {
                return [dismissNavigationItem()]
            } else {
                return [backNavigationItem()]
            }
        }
    }

    @objc open func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        if self is ScreenZLevel1 || self is ScreenZLevel2 || self is ScreenZLevelBottom {
            return [coachNavigationItem()]
        }
        return nil
    }

    @objc open func bottomNavigationBackgroundColor() -> UIColor? {
        return self.view.backgroundColor
    }

    @objc open func coachNavigationItem() -> UIBarButtonItem {
        let button = CoachButton()
        button.addTarget(self, action: #selector(showCoachScreen), for: .touchUpInside)
        button.setImage(R.image.ic_coach(), for: .normal)
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: .Default * 2, height: .Default * 2))
        button.circle()
        button.imageView?.contentMode = .center
        return UIBarButtonItem(customView: button)
    }

    @objc open func backNavigationItem() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.setImage(R.image.arrowBack(), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.accent.cgColor
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: .Default, height: .Default))
        button.circle()
        button.tintColor = .red
        return UIBarButtonItem(customView: button)
    }

    @objc open func dismissNavigationItem(action: Selector? = nil) -> UIBarButtonItem {
        var buttonAction = #selector(didTapDismissButton)
        if let action = action {
            buttonAction = action
        }
        let button = UIButton(type: .custom)
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: .Default, height: .Default))
        button.addTarget(self, action: buttonAction, for: .touchUpInside)
        button.setImage(R.image.ic_close_rounded(), for: .normal)
        button.tintColor = .red
        return UIBarButtonItem(customView: button)
    }

    @objc open func roundedBarButtonItem(title: String,
                                         image: UIImage? = nil,
                                         buttonWidth: CGFloat.Button.Width,
                                         action: Selector,
                                         backgroundColor: UIColor = .carbonDark,
                                         borderColor: UIColor = .clear) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: buttonWidth, height: .Default))
        button.backgroundColor = backgroundColor
        let attributedTitle = NSAttributedString(string: title,
                                                 letterSpacing: 0.2,
                                                 font: .sfProtextSemibold(ofSize: 14),
                                                 textColor: .accent,
                                                 alignment: .center)
        button.setAttributedTitle(attributedTitle, for: .normal)
        if let image = image {
            button.setImage(image, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        }
        button.addTarget(self, action: action, for: .touchUpInside)
        button.corner(radius: Layout.cornerRadius20, borderColor: borderColor)
        return UIBarButtonItem(customView: button)
    }

    @objc open func showCoachScreen() {
        // create Coach ViewController and show on Level3
        guard let coachViewController = R.storyboard.coach().instantiateViewController(withIdentifier: R.storyboard.coach.coachViewControllerID.identifier) as? CoachViewController else {
            return
        }
        CoachConfigurator.make(viewController: coachViewController)
        let navi = UINavigationController(rootViewController: coachViewController)
        navi.modalTransitionStyle = .crossDissolve
        navi.isNavigationBarHidden = true
        navi.isToolbarHidden = true
        navi.view.backgroundColor = .clear
        present(navi, animated: true)
        trackUserEvent(.OPEN, valueType: "COACH", action: .TAP)
    }

    @objc open func didTapBackButton() {
        navigationController?.popViewController(animated: true)
        trackUserEvent(.PREVIOUS, action: .TAP)
    }

    @objc open func didTapDismissButton() {
        NotificationCenter.default.post(name: .didTabDismissBottomNavigation, object: nil)
        dismiss(animated: true, completion: nil)
        trackUserEvent(.CLOSE, action: .TAP)
    }
}
