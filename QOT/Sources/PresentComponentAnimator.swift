//
//  PresentComponentAnimator.swift
//  QOT
//
//  Created by karmic on 26.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class PresentComponentAnimator: NSObject {

    struct Params {
        let fromComponentFrame: CGRect
        let fromCell: ComponentCollectionViewCell
    }

    private let params: Params
    private let presentAnimationDuration: TimeInterval
    private let springAnimator: UIViewPropertyAnimator
    private var transitionDriver: PresentComponentTransitionDriver?

    init(params: Params) {
        self.params = params
        self.springAnimator = PresentComponentAnimator.createBaseSpringAnimator(params: params)
        self.presentAnimationDuration = springAnimator.duration
        super.init()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension PresentComponentAnimator: UIViewControllerAnimatedTransitioning {

    private static func createBaseSpringAnimator(params: PresentComponentAnimator.Params) -> UIViewPropertyAnimator {
        // Damping between 0.7 (far away) and 1.0 (nearer)
        let componentPositionY = params.fromComponentFrame.minY
        let distanceToBounce = abs(params.fromComponentFrame.minY)
        let extentToBounce = componentPositionY < 0 ? params.fromComponentFrame.height : UIScreen.main.bounds.height
        let dampFactorInterval: CGFloat = 0.3
        let damping: CGFloat = 1.0 - dampFactorInterval * (distanceToBounce / extentToBounce)

        // Duration between 0.5 (nearer) and 0.9 (nearer)
        let baselineDuration: TimeInterval = 0.5
        let maxDuration: TimeInterval = 0.9
        let duration: TimeInterval = baselineDuration + (maxDuration - baselineDuration) * TimeInterval(max(0, distanceToBounce)/UIScreen.main.bounds.height)

        let springTiming = UISpringTimingParameters(dampingRatio: damping, initialVelocity: .init(dx: 0, dy: 0))
        return UIViewPropertyAnimator(duration: duration, timingParameters: springTiming)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        // 1.
        return presentAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 2.
        transitionDriver = PresentComponentTransitionDriver(params: params,
                                                            transitionContext: transitionContext,
                                                            baseAnimator: springAnimator)
        interruptibleAnimator(using: transitionContext).startAnimation()
    }

    func animationEnded(_ transitionCompleted: Bool) {
        // 4.
        transitionDriver = nil
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        // 3.
        return transitionDriver!.animator
    }
}
