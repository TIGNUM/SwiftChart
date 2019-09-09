//
//  QOTNavigationController.swift
//  LevelNavigationDemo
//
//  Created by Sanggeon Park on 19.06.19.
//  Copyright © 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit
import qot_dal

var navigationControllerIsSwizzled = false

func swizzleUINavigationController() {
    if navigationControllerIsSwizzled == true {
        return
    }
    swizzlePushViewController()
    swizzlePopViewController()
}

func swizzlePushViewController() {
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

func swizzlePopViewController() {
    let originalSelector = #selector(UINavigationController.popViewController(animated:))
    let swizzledSelector = #selector(UINavigationController.popViewControllerSwizzeld(animated:))

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
        viewController.refreshBottomNavigationItems()
        let viewControllerName = NSStringFromClass(type(of: self))
        log("swizzled pushViewController: \(viewControllerName)", level: .verbose)
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
                dismissAllPresentedViewControllers(presentedViewController, animated, completion: {
                    self.dismissAllPresentedViewControllers(self, true, completion: {})
                })
            }
        } else {
            pushViewControllerSwizzled(viewController: viewController, animated: animated)
        }
    }

    @objc func popViewControllerSwizzeld(animated: Bool) -> UIViewController? {
        let last = popViewControllerSwizzeld(animated: true)
        if last != nil {
            let viewControllerName = NSStringFromClass(type(of: last!))
            log("swizzled popViewController: \(viewControllerName)", level: .verbose)
            viewControllers.last?.refreshBottomNavigationItems()
        }
        return last
    }

    func dismissAllPresentedViewControllers(_ root: UIViewController,
                                            _ animated: Bool,
                                            _ index: Int = 0,
                                            completion: @escaping (() -> Void)) {
        let newCompletion: (() -> Void) = {
            if index == 0 { // if there is nothing presented.
                DispatchQueue.main.async {
                    completion()
                }
            } else {
                root.dismiss(animated: animated, completion: completion)
            }
        }
        if let currentPresentedViewController = root.presentedViewController {
            dismissAllPresentedViewControllers(currentPresentedViewController, animated, index + 1, completion: newCompletion)
        } else {
            if index == 0 { // if there is nothing presented.
                DispatchQueue.main.async {
                    completion()
                }
            } else {
                root.dismiss(animated: animated, completion: completion)
            }
        }
    }

    func presentModal(_ vc: UIViewController,
                      from sender: UIViewController,
                      animated: Bool, completion: (() -> Void)? = nil) {
        if presentedViewController == nil {
            topViewController?.presentSwizzled(viewControllerToPresent: vc, animated: animated, completion: completion)
        } else if let naviVC = presentedViewController as? UINavigationController {
            naviVC.presentModal(vc, from: sender, animated: animated, completion: completion)
        } else {
            sender.presentSwizzled(viewControllerToPresent: vc, animated: animated, completion: completion)
        }
    }
}
