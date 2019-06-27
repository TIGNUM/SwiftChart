//
//  QOTNavigationController.swift
//  LevelNavigationDemo
//
//  Created by Sanggeon Park on 19.06.19.
//  Copyright © 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit

public enum NavigationZLevel: Int {
    case unknown = 0
    case zLevel1 = 1
    case zLevel2 = 2
    case zLevel3 = 3
}

var navigationControllerIsSwizzled = false

func swizzleUINavigationControllerPushViewController() {
    if navigationControllerIsSwizzled == true {
        return
    }
    let originalSelector = #selector(UINavigationController.pushViewController(_:animated:))
    let swizzledSelector = #selector(UINavigationController.pushViewControllerSwizzled(viewController:animated:))

    let originalMethod = class_getInstanceMethod(UINavigationController.self, originalSelector)
    let swizzledMethod = class_getInstanceMethod(UINavigationController.self, swizzledSelector)

    if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
        // switch implementation..
        method_exchangeImplementations(originalMethod, swizzledMethod)
        navigationControllerIsSwizzled = !navigationControllerIsSwizzled
    }
}

weak var baseRootViewController: BaseRootViewController?

extension UINavigationController {
    @objc func pushViewControllerSwizzled(viewController: UIViewController, animated: Bool) {
        let viewControllerName = NSStringFromClass(type(of: self))
        print("pushViewController: \(viewControllerName)")
        guard let navigationController = baseRootViewController?.navigationController else {
            pushViewControllerSwizzled(viewController: viewController, animated: animated)
            return
        }

        let currentTopViewController = navigationController.topViewController
        var currentPresentedViewController = navigationController.presentedViewController
        if currentPresentedViewController == currentTopViewController {
            currentPresentedViewController = nil
        }

        var leveledViewController: UIViewController? = nil
        var parentNavigationController: UINavigationController = self
        while leveledViewController == nil {
            if let naviController = parentNavigationController.viewControllers.first as? UINavigationController {
                parentNavigationController = naviController
            } else if parentNavigationController.viewControllers.first != nil {
                leveledViewController = parentNavigationController.viewControllers.first
            } else {
                break
            }
        }

        if leveledViewController is ScreenZLevel1 || viewController is ScreenZLevel2 {
            navigationController.pushViewControllerSwizzled(viewController: viewController, animated: animated)
            // TODO: Dismiss all Presented ViewControllers
            if let presentedViewController = currentPresentedViewController {
                dismissAllPresentedViewControllers(presentedViewController, animated, completion: {})
            }
        } else {
            pushViewControllerSwizzled(viewController: viewController, animated: animated)
        }
    }

    func dismissAllPresentedViewControllers(_ root: UIViewController,
                                            _ animated: Bool,
                                            completion: @escaping (() -> Void)) {
        let newCompletion: (() -> Void) = {
            root.dismiss(animated: animated, completion: completion)
        }
        if let currentPresentedViewController = root.presentedViewController {
            dismissAllPresentedViewControllers(currentPresentedViewController, animated, completion: newCompletion)
        } else {
            root.dismiss(animated: animated, completion: completion)
        }
    }

    func presentModal(_ vc: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        if presentedViewController == nil {
            topViewController?.presentSwizzled(viewControllerToPresent: vc, animated: animated, completion: completion)
        } else if let naviVC = presentedViewController as? UINavigationController {
            naviVC.presentModal(vc, animated: animated, completion: completion)
        } else {
            fatalError("Cannot find UINavigationController")
        }
    }
}
