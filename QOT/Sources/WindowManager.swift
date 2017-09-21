//
//  WindowManager.swift
//  QOT
//
//  Created by Lee Arromba on 30/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class WindowManager {

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
            if window != normalWindow {
                window.isHidden = true
            }
        }
    }
    
    func rootViewController(atLevel level: Level) -> UIViewController? {
        let window = windowForLevel(level)
        return window.rootViewController
    }
    
    func setRootViewController(_ viewController: UIViewController, atLevel level: Level, animated: Bool, completion: (() -> Void)?) {
        let window = windowForLevel(level)
        if animated {
            window.setRootViewControllerWithFadeAnimation(viewController, completion: completion)
        } else {
            window.rootViewController = viewController
        }
    }
    
    func presentViewController(_ viewController: UIViewController, atLevel level: Level, animated: Bool, replacesContent: Bool = false, completion: (() -> Void)?) {
        let window = windowForLevel(level)
        if window.rootViewController?.presentedViewController != nil {
            if replacesContent == true {
                window.rootViewController?.dismiss(animated: animated, completion: {
                    window.rootViewController?.present(viewController, animated: animated, completion: completion)
                })
            }
        } else {
            window.rootViewController?.present(viewController, animated: animated, completion: completion)
        }
    }
    
    func resignWindow(atLevel level: Level) {
        guard level != .normal else {
            fatalError("can't resign the normal window")
        }

        let window = windowForLevel(level)
        window.isHidden = true
        clearWindow(atLevel: level)
    }
    
    func showWindow(atLevel level: Level) {
        let window = windowForLevel(level)
        window.isHidden = false
    }
    
    func hasContent(atLevel level: Level) -> Bool {
        let window = windowForLevel(level)

        return window.rootViewController?.presentedViewController != nil
    }
    
    func clearWindow(atLevel level: Level) {
        let window = windowForLevel(level)
        window.clear()
        window.rootViewController = createBaseViewController()
    }

    func clearWindows() {
        allWindows.forEach { (window: UIWindow) in
            window.clear()
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
}
