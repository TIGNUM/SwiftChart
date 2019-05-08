//
//  LearnListAnimator.swift
//  QOT
//
//  Created by Moucheg Mouradian on 25/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnListAnimator: NSObject {

    private let duration: TimeInterval

    init(duration: TimeInterval = Animation.duration_03) {
        self.duration = duration
        super.init()
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension LearnListAnimator: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LearnListAnimation(isPresenting: true, duration: duration)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LearnListAnimation(isPresenting: false, duration: duration)
    }
}
