//
//  UIViewController+Transition.swift
//  QOT
//
//  Created by karmic on 24.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func presentRightToLeft(controller: UIViewController) {
        DispatchQueue.main.async {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            self.view.window?.layer.add(transition, forKey: kCATransition)

            if let nav = self.navigationController {
                nav.pushViewController(controller, animated: false)
            } else {
                self.present(controller, animated: false, completion: nil)
            }
        }
    }

    func dismissLeftToRight() {
        DispatchQueue.main.async {
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            self.view.window?.layer.add(transition, forKey: kCATransition)

            var navController: UINavigationController? = nil
            if let nav = self as? UINavigationController {
                navController = nav
            } else if let nav = self.navigationController {
                navController = nav
            }

            if let nav = navController {
                nav.popViewController(animated: false)
            } else {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}
