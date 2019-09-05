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
var viewDidAppearIsSwizzled = false
var presentViewControllerIsSwizzled = false
var dismissViewControllerIsSwizzled = false
var timer: Timer?

func swizzleUIViewController() {
    if viewWillAppearIsSwizzled == false {
        swizzleUIViewControllerViewWillAppear()
    }

    if viewDidAppearIsSwizzled == false {
        swizzleUIViewControllerViewDidAppear()
    }

    if presentViewControllerIsSwizzled == false {
        swizzleUIViewControllerPresentViewController()
    }

    if dismissViewControllerIsSwizzled == false {
        swizzleUIViewControllerDismissViewController()
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

func swizzleUIViewControllerViewDidAppear() {
    let originalSelector = #selector(UIViewController.viewDidAppear(_:))
    let swizzledSelector = #selector(UIViewController.viewDidAppearSwizzled(animated:))

    let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
    let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)

    if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
        // switch implementation..
        method_exchangeImplementations(originalMethod, swizzledMethod)
        viewDidAppearIsSwizzled = !viewDidAppearIsSwizzled
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

func swizzleUIViewControllerDismissViewController() {
    let originalSelector = #selector(UIViewController.dismiss(animated:completion:))
    let swizzledSelector = #selector(UIViewController.dismissSwizzled(animated:completion:))

    let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
    let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)

    if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
        // switch implementation..
        method_exchangeImplementations(originalMethod, swizzledMethod)
        dismissViewControllerIsSwizzled = !dismissViewControllerIsSwizzled
    }
}

extension UIViewController {

    func isTopVisibleViewController() -> Bool {
        guard let window = UIApplication.shared.keyWindow else {
            return false
        }
        let center = window.frame.center
        guard let view = window.hitTest(center, with: nil) else {
            return false
        }

        var parentView: UIView? = view
        while parentView != nil && parentView != window {
            if parentView == self.view {
                return true
            }
            parentView = parentView?.superview
        }

        return false
    }

    @objc func viewWillAppearSwizzled(animated: Bool) {
        let viewControllerName = NSStringFromClass(type(of: self))
        log("swizzled viewWillAppear: \(viewControllerName), animated: \(animated)", level: .info)

        self.applyTheme()
        if animated && isTopVisibleViewController() {
            refreshBottomNavigationItems()
            setStatusBar(color: view.backgroundColor)
            self.setNeedsStatusBarAppearanceUpdate()
        }
        self.viewWillAppearSwizzled(animated: animated)
    }

    @objc func viewDidAppearSwizzled(animated: Bool) {
        if self is ScreenZLevel1 || self is ScreenZLevelBottom {
            NotificationCenter.default.post(name: .stopAudio, object: nil)
        } else if self is ScreenZLevel2 {
            addGestureSwipeBack()
        }

        let viewControllerName = NSStringFromClass(type(of: self))
        log("swizzled viewDidAppear: \(viewControllerName), animated: \(animated)", level: .info)

        if isTopVisibleViewController() {
            refreshBottomNavigationItems()
            setStatusBar(color: view.backgroundColor)
            self.setNeedsStatusBarAppearanceUpdate()
        }
        self.viewDidAppearSwizzled(animated: animated)
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

    @objc func handleSwipeBackGesture(gesture: UISwipeGestureRecognizer) {
        dismissLeftToRight()
    }

    private func addGestureSwipeBack() {
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeBackGesture))
        swipeBack.direction = .right
        view.addGestureRecognizer(swipeBack)
    }

    private func navigationNotificationBlock() -> (() -> Void)? {
        return { [weak self] in
            DispatchQueue.main.async {
                guard let strongself = self else { return }
                if strongself.view.window != nil {
                    let item = BottomNavigationItem(leftBarButtonItems: strongself.bottomNavigationLeftBarItems() ?? [],
                                                    rightBarButtonItems: strongself.bottomNavigationRightBarItems() ?? [],
                                                    backgroundColor: strongself.bottomNavigationBackgroundColor() ?? .clear)
                    let notification = Notification(name: .updateBottomNavigation, object: item, userInfo: nil)
                    NotificationCenter.default.post(notification)
                }
            }
        }
    }

    @objc func presentSwizzled(viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let viewControllerName = NSStringFromClass(type(of: viewControllerToPresent))
        log("swizzled   present: \(viewControllerName)", level: .verbose)
        viewControllerToPresent.refreshBottomNavigationItems()
        if viewControllerToPresent is UIActivityViewController || viewControllerToPresent is UIAlertController {
            presentSwizzled(viewControllerToPresent: viewControllerToPresent, animated: animated, completion: completion)
            return
        }
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

    @objc func dismissSwizzled(animated flag: Bool, completion: (() -> Void)? = nil) {
        let viewControllerName = NSStringFromClass(type(of: self))
        log("swizzled   dismiss: \(viewControllerName)", level: .verbose)
        dismissSwizzled(animated: flag, completion: completion)
        // get presenting.
        self.presentingViewController?.QOTVisibleViewController()?.refreshBottomNavigationItems()
    }
}

extension UIViewController {
    @objc open func QOTVisibleViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.QOTVisibleViewController()
        }

        if let tabBarController = self as? UITabBarController {
            if let viewController = tabBarController.selectedViewController {
                return viewController.QOTVisibleViewController()
            }
        }

        if let pageViewController = self as? UIPageViewController {
            if let viewController = pageViewController.viewControllers?.first {
                return viewController.QOTVisibleViewController()
            }
        }

        return self
    }

    @objc open func refreshBottomNavigationItems() {
        let swiftClassName = NSStringFromClass(type(of: self))
        if self is ScreenZLevelIgnore {
            return
        }
        if (self is ScreenZLevelOverlay) ||
            swiftClassName == "UIViewController" ||
            swiftClassName == "INUIVoiceShortcutHostViewController" {
            log("hide BottomNavigationBar for : \(swiftClassName)", level: .info)
            DispatchQueue.main.async { [weak self] in
                guard let strongself = self else { return }
                if strongself.view.window != nil {
                    NotificationCenter.default.post(name: .updateBottomNavigation,
                                                    object: BottomNavigationItem(leftBarButtonItems: [],
                                                                                 rightBarButtonItems: [], backgroundColor: .clear),
                                                    userInfo: nil)
                }
            }
        } else if (self as? UINavigationController) == nil,
            (self as? UIPageViewController) == nil,
            ((self as? ScreenZLevel1) != nil || (self as? ScreenZLevel2) != nil || (self as? ScreenZLevel3) != nil) {
            log("refreshBottomNavigationItems for : \(swiftClassName)", level: .info)
            if let notificationBlock = navigationNotificationBlock() {
                notificationBlock()
            }
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
            } else if self.showTransitionBackButton() {
                return [backNavigationItem()]
            } else {
                return []
            }
        }
    }

    @objc open func showTransitionBackButton() -> Bool {
        return true
    }

    @objc open func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc open func bottomNavigationBackgroundColor() -> UIColor? {
        return self.view.backgroundColor
    }

    @objc open func backNavigationItem() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.setImage(R.image.ic_back_rounded(), for: .normal)
        button.imageView?.contentMode = .center
        button.backgroundColor = .clear
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: .Default, height: .Default))
        return UIBarButtonItem(customView: button)
    }

    @objc open func dismissNavigationItem(action: Selector? = nil) -> UIBarButtonItem {
        var buttonAction = #selector(didTapDismissButton)
        if let action = action {
            buttonAction = action
        }
        let button = UIButton(type: .custom)
        button.addTarget(self, action: buttonAction, for: .touchUpInside)
        button.setImage(R.image.ic_close_rounded(), for: .normal)
        button.imageView?.contentMode = .center
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: .Default, height: .Default))
        return UIBarButtonItem(customView: button)
    }

    @objc open func roundedBarButtonItem(title: String,
                                         image: UIImage? = nil,
                                         buttonWidth: CGFloat.Button.Width,
                                         action: Selector,
                                         textColor: UIColor = .accent,
                                         backgroundColor: UIColor = .carbonNew,
                                         borderColor: UIColor = .clear) -> UIBarButtonItem {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: buttonWidth, height: .Default)))
        button.backgroundColor = backgroundColor
        button.setAttributedTitle(NSAttributedString(string: title,
                                                     letterSpacing: 0.2,
                                                     font: .sfProtextSemibold(ofSize: 14),
                                                     textColor: textColor,
                                                     alignment: .center),
                                  for: .normal)
        if let image = image {
            button.setImage(image, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        }
        button.titleEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.corner(radius: Layout.cornerRadius20, borderColor: borderColor)
        return UIBarButtonItem(customView: button)
    }

    @objc open func didTapBackButton() {
        navigationController?.dismissLeftToRight()
        trackUserEvent(.PREVIOUS, action: .TAP)
    }

    @objc open func didTapDismissButton() {
        NotificationCenter.default.post(name: .didTabDismissBottomNavigation, object: nil)
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
        trackUserEvent(.CLOSE, action: .TAP)
    }
}

// MARK: Theme Factory
extension UIViewController {
    func applyTheme() {
        view.applyTheme(view)
    }
}

extension UICollectionViewCell {
    override open func awakeFromNib() {
        super.awakeFromNib()
        applyTheme(contentView)
    }
}

extension UITableViewCell {
    override open func awakeFromNib() {
        super.awakeFromNib()
        applyTheme(contentView)
    }
}

extension UINavigationController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        if let vc = self.viewControllers.last {
            return vc.preferredStatusBarStyle
        }
        return .lightContent
    }
}

extension UIView {
    override open func value(forUndefinedKey key: String) -> Any? {
        return nil
    }

    func applyTheme(_ targetView: UIView) {
//        if let theme = targetView.themeView {
//            theme.apply(targetView)
//        }

//        for subView in targetView.subviews {
//            if let label = subView as? UILabel {
//                if let text = label.text,
//                    let theme = label.themeText {
//                    theme.apply(text, to: label)
//                } else {
//                    label.backgroundColor = UIColor.yellow   //use this to show unthemed componenets
//                }
//            } else if !subView.subviews.isEmpty {
//                applyTheme(subView)
//            }
//        }
    }

//    var themeView: ThemeView? {
//        get {
//            if let themeKey = self.value(forKeyPath: "ThemeView") as? String,
//                let theme = ThemeView(rawValue: themeKey) {
//                return theme
//            }
//            return nil
//        }
//        set {
//            if let value = newValue?.rawValue {
//                self.setValue(value, forKeyPath: "ThemeView")
//            }
//        }
//    }

}

//extension UILabel {
//    var themeText: ThemeText? {
//        get {
//            if let themeKey = self.value(forKeyPath: "ThemeText") as? String,
//                let theme = ThemeText(rawValue: themeKey) {
//                return theme
//            }
//            return nil
//        }
//        set {
//            if let value = newValue?.rawValue {
//                self.setValue(value, forKeyPath: "ThemeText")
//            }
//        }
//    }
//}
