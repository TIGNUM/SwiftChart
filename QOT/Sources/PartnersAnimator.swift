//
//  PartnersAnimator.swift
//  QOT
//
//  Created by Moucheg Mouradian on 25/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class PartnersAnimator: NSObject {

    private let duration: TimeInterval

    init(duration: TimeInterval = 0.4) {
        self.duration = duration
        super.init()
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension PartnersAnimator: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PartnersAnimation(isPresenting: true, duration: duration)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PartnersAnimation(isPresenting: false, duration: duration)
    }
}
