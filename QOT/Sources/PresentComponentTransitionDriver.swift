//
//  PresentComponentTransitionDriver.swift
//  QOT
//
//  Created by karmic on 26.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class PresentComponentTransitionDriver {
    let animator: UIViewPropertyAnimator

    init(params: PresentComponentAnimator.Params,
         transitionContext: UIViewControllerContextTransitioning,
         baseAnimator: UIViewPropertyAnimator) {
        let context = transitionContext
        let container = context.containerView
        let screens: (home: HomeViewController?, componentDetail: ComponentDetailViewController?) = (
            context.viewController(forKey: .from) as? HomeViewController,
            context.viewController(forKey: .to) as? ComponentDetailViewController
        )

        let componentDetailView = context.view(forKey: .to) ?? UIView()
        let fromComponentFrame = params.fromComponentFrame

        // Temporary container view for animation
        let animatedContainerView = UIView()
        animatedContainerView.translatesAutoresizingMaskIntoConstraints = false
        if GlobalConstants.isEnabledDebugAnimatingViews {
            animatedContainerView.layer.borderColor = UIColor.yellow.cgColor
            animatedContainerView.layer.borderWidth = 4
            componentDetailView.layer.borderColor = UIColor.red.cgColor
            componentDetailView.layer.borderWidth = 2
        }
        container.addSubview(animatedContainerView)

        do /* Fix centerX/width/height of animated container to container */ {
            let animatedContainerConstraints = [
                animatedContainerView.widthAnchor.constraint(equalToConstant: container.bounds.width),
                animatedContainerView.heightAnchor.constraint(equalToConstant: container.bounds.height),
                animatedContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor)]
            NSLayoutConstraint.activate(animatedContainerConstraints)
        }

        let animatedContainerVerticalConstraint: NSLayoutConstraint = {
            switch GlobalConstants.cardVerticalExpandingStyle {
            case .fromCenter:
                return animatedContainerView.centerYAnchor.constraint(
                    equalTo: container.centerYAnchor,
                    constant: (fromComponentFrame.height/2 + fromComponentFrame.minY) - container.bounds.height/2
                )
            case .fromTop:
                return animatedContainerView.topAnchor.constraint(equalTo: container.topAnchor, constant: fromComponentFrame.minY)
            }

        }()
        animatedContainerVerticalConstraint.isActive = true
        animatedContainerView.addSubview(componentDetailView)
        componentDetailView.translatesAutoresizingMaskIntoConstraints = false
        let weirdCardToAnimatedContainerTopAnchor: NSLayoutConstraint

        do /* Pin top (or center Y) and center X of the card, in animated container view */ {
            let verticalAnchor: NSLayoutConstraint = {
                switch GlobalConstants.cardVerticalExpandingStyle {
                case .fromCenter:
                    return componentDetailView.centerYAnchor.constraint(equalTo: animatedContainerView.centerYAnchor)
                case .fromTop:
                    // WTF: SUPER WEIRD BUG HERE.
                    // I should set this constant to 0 (or nil), to make componentDetailView sticks to the animatedContainerView's top.
                    // BUT, I can't set constant to 0, or any value in range (-1,1) here, or there will be abrupt top space inset while animating.
                    // Funny how -1 and 1 work! WTF. You can try set it to 0.
                    return componentDetailView.topAnchor.constraint(equalTo: animatedContainerView.topAnchor, constant: -1)
                }
            }()
            let cardConstraints = [
                verticalAnchor,
                componentDetailView.centerXAnchor.constraint(equalTo: animatedContainerView.centerXAnchor),]
            NSLayoutConstraint.activate(cardConstraints)
        }
        let componentWidthConstraint = componentDetailView.widthAnchor.constraint(equalToConstant: fromComponentFrame.width)
        let componentHeightConstraint = componentDetailView.heightAnchor.constraint(equalToConstant: fromComponentFrame.height)
        NSLayoutConstraint.activate([componentWidthConstraint, componentHeightConstraint])
        componentDetailView.layer.cornerRadius = GlobalConstants.cardCornerRadius

        // -------------------------------
        // Final preparation
        // -------------------------------
        params.fromCell.isHidden = true
        params.fromCell.resetTransform()
        let topTemporaryFix = screens.componentDetail?.componentContentView.topAnchor.constraint(equalTo: componentDetailView.topAnchor, constant: 0)
        topTemporaryFix?.isActive = GlobalConstants.isEnabledWeirdTopInsetsFix
        container.layoutIfNeeded()

        // ------------------------------
        // 1. Animate container bouncing up
        // ------------------------------
        func animateContainerBouncingUp() {
            animatedContainerVerticalConstraint.constant = 0
            container.layoutIfNeeded()
        }

        // ------------------------------
        // 2. Animate componentDetail filling up the container
        // ------------------------------
        func animateComponentDetailViewSizing() {
            componentWidthConstraint.constant = animatedContainerView.bounds.width
            componentHeightConstraint.constant = animatedContainerView.bounds.height
            componentDetailView.layer.cornerRadius = 0
            container.layoutIfNeeded()
        }

        func completeEverything() {
            // Remove temporary `animatedContainerView`
            animatedContainerView.removeConstraints(animatedContainerView.constraints)
            animatedContainerView.removeFromSuperview()

            // Re-add to the top
            container.addSubview(componentDetailView)

            if let topTemporaryFix = topTemporaryFix {
                componentDetailView.removeConstraints([topTemporaryFix, componentWidthConstraint, componentHeightConstraint])
            }

            // Keep -1 to be consistent with the weird bug above.
            componentDetailView.edges(to: container, top: -1)

            // No longer need the bottom constraint that pins bottom of card content to its root.
            screens.componentDetail?.componentBottomToRootBottomConstraint.isActive = false
            screens.componentDetail?.scrollView.isScrollEnabled = true
            let success = !context.transitionWasCancelled
            context.completeTransition(success)
        }

        baseAnimator.addAnimations {

            // Spring animation for bouncing up
            animateContainerBouncingUp()

            // Linear animation for expansion
            let cardExpanding = UIViewPropertyAnimator(duration: baseAnimator.duration * 0.6, curve: .linear) {
                animateComponentDetailViewSizing()
            }
            cardExpanding.startAnimation()
        }

        baseAnimator.addCompletion { (_) in
            completeEverything()
        }
        self.animator = baseAnimator
    }
}
