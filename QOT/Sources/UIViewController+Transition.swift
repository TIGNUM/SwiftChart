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
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window?.layer.add(transition, forKey: kCATransition)
        present(controller, animated: false, completion: nil)
    }

    func dismissLeftToRight() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }

    @objc func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
