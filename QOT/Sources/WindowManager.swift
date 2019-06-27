//
//  WindowManager.swift
//  QOT
//
//  Created by Lee Arromba on 30/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class WindowManager {
    enum Level {
        case alert
        case priority
        case overlay
        case normal

        var windowLevel: UIWindowLevel {
            switch self {
            case .alert:
                return UIWindowLevelAlert
            case .priority:
                return UIWindowLevelNormal + 2
            case .overlay:
                return UIWindowLevelNormal + 1
            case .normal:
                return UIWindowLevelNormal
            }
        }
    }

    private let alertWindow: UIWindow       // major alerts
    private let priorityWindow: UIWindow    // priority information
    private let overlayWindow: UIWindow     // transparent views over main window
    private let normalWindow: UIWindow      // main app content
    private var allWindows: [UIWindow] {
        return [
            alertWindow,
            priorityWindow,
            overlayWindow,
            normalWindow
        ]
    }

    init(alertWindow: UIWindow, priorityWindow: UIWindow, overlayWindow: UIWindow, normalWindow: UIWindow) {
        self.alertWindow = alertWindow
        self.priorityWindow = priorityWindow
        self.overlayWindow = overlayWindow
        self.normalWindow = normalWindow

        alertWindow.windowLevel = Level.alert.windowLevel
        priorityWindow.windowLevel = Level.priority.windowLevel
        overlayWindow.windowLevel = Level.overlay.windowLevel
        normalWindow.windowLevel = Level.normal.windowLevel

        allWindows.forEach { (window: UIWindow) in
            window.rootViewController = createBaseViewController()
            window.makeKeyAndVisible()
            window.isHidden = (window != normalWindow)
        }
    }

    func rootViewController(atLevel level: Level) -> UIViewController? {
        let window = windowForLevel(level)
        return window.rootViewController
    }

    func presentedViewController(atLevel level: Level) -> UIViewController? {
        let window = windowForLevel(level)
        return window.rootViewController?.presentedViewController
    }

    func show(_ viewController: UIViewController, duration: Double = 0.7, animated: Bool, completion: (() -> Void)?) {
        let level = Level.normal
        showWindow(atLevel: level)
        setRootViewController(viewController,
                              transitionStyle: .transitionCrossDissolve,
                              duration: duration,
                              atLevel: level,
                              animated: animated,
                              completion: completion)
    }

    func showOverlay(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let level = Level.overlay
        showWindow(atLevel: level)
        presentViewController(viewController, atLevel: level, animated: animated, completion: completion)
    }

    func showPriority(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let level = Level.priority
        showWindow(atLevel: .priority)
        presentViewController(viewController, atLevel: level, animated: animated, completion: completion)
    }

    func showInfo(helpSection: ScreenHelp.Category) {
        let configurator = ScreenHelpConfigurator.make(helpSection)
        let infoViewController = ScreenHelpViewController(configurator: configurator, category: helpSection)
        presentViewController(infoViewController, atLevel: .normal, animated: true, completion: nil)
    }

    func showSubscriptionReminder(isExpired: Bool) {
        let configurator = PaymentReminderConfigurator.make(isExpired: isExpired)
        let controller = PaymentReminderViewController(configure: configurator)
        showPriority(controller, animated: true, completion: nil)
    }

    func showAlert(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let level = Level.alert
        showWindow(atLevel: .alert)
        presentViewController(viewController, atLevel: level, animated: animated, completion: completion)
    }

    func resignWindow(atLevel level: Level) {
        guard level != .normal else {
            assertionFailure("can't resign the normal window")
            return
        }
        let window = windowForLevel(level)
        window.isHidden = true
        clearWindow(atLevel: level)
    }

    func showWindow(atLevel level: Level) {
        let window = windowForLevel(level)
        window.isHidden = false
        window.makeKey()
    }

    func clearWindow(atLevel level: Level) {
        let window = windowForLevel(level)
        window.rootViewController?.presentedViewController?.dismiss(animated: false, completion: nil)
        window.rootViewController = createBaseViewController()
    }

    func clearWindows() {
        allWindows.forEach { (window: UIWindow) in
            window.rootViewController?.presentedViewController?.dismiss(animated: false, completion: nil)
            window.rootViewController = createBaseViewController()
        }
    }

    // MARK: - private

    private func windowForLevel(_ level: Level) -> UIWindow {
        switch level {
        case .alert: return alertWindow
        case .priority: return priorityWindow
        case .overlay: return overlayWindow
        case .normal: return normalWindow
        }
    }

    private func createBaseViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        viewController.view.frame = UIScreen.main.bounds
        return viewController
    }

    private func setRootViewController(_ viewController: UIViewController, transitionStyle: UIViewAnimationOptions, duration: TimeInterval, atLevel level: Level, animated: Bool, completion: (() -> Void)?) {
        let window = windowForLevel(level)
        guard let rootViewController = window.rootViewController else {
            assertionFailure("rootViewController should not be nil")
            return
        }
        // FIXME: Setting the frame here is necessary to avoid an unintended animation in some situations.
        // Not sure why this is happening. We should investigate.
        viewController.view.frame = rootViewController.view.bounds
        viewController.view.layoutIfNeeded()
        UIView.transition(with: window, duration: duration, options: transitionStyle, animations: {
            window.rootViewController = viewController
        }, completion: { _ in
            completion?()
        })
    }

    private func presentViewController(_ viewController: UIViewController, atLevel level: Level, animated: Bool, completion: (() -> Void)?) {
        let window = windowForLevel(level)
        guard let rootViewController = window.rootViewController else {
            assertionFailure("rootViewController should not be nil")
            return
        }
        // FIXME: Setting the frame here is necessary to avoid an unintended animation in some situations.
        // Not sure why this is happening. We should investigate.
        viewController.view.frame = rootViewController.view.bounds
        rootViewController.presentedViewController?.dismiss(animated: false, completion: nil)
        rootViewController.present(viewController, animated: animated, completion: completion)
    }
}
