//
//  ContentItemAnimator.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 7/14/17.
//  Copyright © 2017 Tignum. All rights reserved.
//
//

import Foundation
import UIKit

final class ContentItemAnimator: NSObject {
    private let originFrame: CGRect
    private let duration: TimeInterval

    init(originFrame: CGRect, duration: TimeInterval = 0.6) {
        self.originFrame = originFrame
        self.duration = duration
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension ContentItemAnimator: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ContentItemAnimation(isPresenting: true, duration: duration, originFrame: originFrame)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ContentItemAnimation(isPresenting: false, duration: duration, originFrame: originFrame)
    }
}
