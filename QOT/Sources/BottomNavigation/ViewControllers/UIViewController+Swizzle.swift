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
        print("viewWillAppear: \(viewControllerName)")

        refreshBottomNavigationItems()
        self.viewWillAppearSwizzled(animated: animated)
    }

    private func navigationNotificationBlock() -> (() -> Void)? {
        return { [weak self] in
            DispatchQueue.main.async {
                let navigationItem = BottomNavigationItem(leftBarButtonItems: self?.bottomNavigationLeftBarItems() ?? [],
                                                          rightBarButtonItems: self?.bottomNavigationRightBarItems() ?? [],
                                                          backgroundColor: self?.view.backgroundColor ?? .clear)
                let notification = Notification(name: .updateBottomNavigation, object: navigationItem, userInfo: nil)
                NotificationCenter.default.post(notification)
            }
        }
    }

    @objc func presentSwizzled(viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if viewControllerToPresent is UIAlertController {
            presentSwizzled(viewControllerToPresent: viewControllerToPresent, animated: animated, completion: completion)
            return
        }
        let viewControllerName = NSStringFromClass(type(of: viewControllerToPresent))
        print("present: \(viewControllerName)")
        var vc = viewControllerToPresent
        if (vc as? UINavigationController) == nil {
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
            let notificationBlock = navigationNotificationBlock() {
            notificationBlock()
        } else if (self as? UIAlertController) != nil {
            let navigationItem = BottomNavigationItem(leftBarButtonItems: [],
                                                      rightBarButtonItems: [],
                                                      backgroundColor: .clear)
            let notification = Notification(name: .updateBottomNavigation, object: navigationItem, userInfo: nil)
            NotificationCenter.default.post(notification)
        }
    }

    @objc open func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        if (self as? ScreenZLevel1) == nil && self.navigationController?.viewControllers.first == self {
            return [dismissNavigationItem()]
        } else if (self as? ScreenZLevel1) == nil && (self as? ScreenZLevelBottom) == nil {
            return [backNavigationItem()]
        }

        return nil
    }

    @objc open func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        if self is ScreenZLevel1 || self is ScreenZLevel2 || self is ScreenZLevelBottom {
            return [coachNavigationItem()]
        }
        return nil
    }

    @objc open func coachNavigationItem() -> UIBarButtonItem {
        let button = CoachButton()
        let buttonHeight: CGFloat = 80
        button.addTarget(self, action: #selector(showCoachScreen), for: .touchUpInside)
        button.setImage(R.image.ic_coach(), for: .normal)
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: buttonHeight, height: buttonHeight))
        button.corner(radius: buttonHeight / 2)
        button.imageView?.contentMode = .center
        return UIBarButtonItem(customView: button)
    }

    @objc open func backNavigationItem() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        let buttonHeight: CGFloat = 40
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.setImage(R.image.arrowBack(), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.accent.cgColor
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: buttonHeight, height: buttonHeight))
        button.corner(radius: buttonHeight / 2)
        button.tintColor = .red
        return UIBarButtonItem(customView: button)
    }

    @objc open func dismissNavigationItem() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        let buttonHeight: CGFloat = 40
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: buttonHeight, height: buttonHeight))
        button.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
        button.setImage(R.image.ic_close_rounded(), for: .normal)
        button.tintColor = .red
        return UIBarButtonItem(customView: button)
    }

    @objc open func showCoachScreen() {
        // create Coach ViewController and show on Level3
        guard let coachViewController = R.storyboard.main().instantiateViewController(withIdentifier: R.storyboard.main.coachViewControllerID.identifier) as? CoachViewController else {
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
        dismiss(animated: true, completion: nil)
        trackUserEvent(.CLOSE, action: .TAP)
    }
}

extension AVPlayerViewController {
    @objc override open func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}
