//
//  MyToBeVisionAnimator.swift
//  QOT
//
//  Created by Moucheg Mouradian on 25/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MyToBeVisionAnimator: NSObject {

    fileprivate let duration: TimeInterval

    init(duration: TimeInterval = 0.4) {
        self.duration = duration
        super.init()
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension MyToBeVisionAnimator: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyToBeVisionAnimation(isPresenting: true, duration: duration)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyToBeVisionAnimation(isPresenting: false, duration: duration)
    }
}
