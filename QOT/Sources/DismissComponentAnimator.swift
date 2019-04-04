//
//  DismissComponentAnimator.swift
//  QOT
//
//  Created by karmic on 25.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class DismissComponentAnimator: NSObject {
    struct Params {
        let fromComponentFrame: CGRect
        let fromComponentWithoutTransform: CGRect
        let fromCell: ComponentCollectionViewCell
    }

    struct Constants {
        static let relativeDurationBeforeNonInteractive: TimeInterval = 0.5
        static let minimumScaleBeforeNonInteractive: CGFloat = 0.8
    }

    private let params: Params

    init(params: Params) {
        self.params = params
        super.init()
    }
}

extension DismissComponentAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return GlobalConstants.dismissalAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let ctx = transitionContext
        let container = ctx.containerView
        let screens: (cardDetail: ComponentDetailViewController?, home: HomeViewController?) = (
            ctx.viewController(forKey: .from) as? ComponentDetailViewController,
            ctx.viewController(forKey: .to) as? HomeViewController
        )
        let componentDetailView = ctx.view(forKey: .from)
        let animatedContainerView = UIView()
        if GlobalConstants.isEnabledDebugAnimatingViews {
            animatedContainerView.layer.borderColor = UIColor.yellow.cgColor
            animatedContainerView.layer.borderWidth = 4
            componentDetailView?.layer.borderColor = UIColor.red.cgColor
            componentDetailView?.layer.borderWidth = 2
        }
        animatedContainerView.translatesAutoresizingMaskIntoConstraints = false
        componentDetailView?.translatesAutoresizingMaskIntoConstraints = false

        container.removeConstraints(container.constraints)

        container.addSubview(animatedContainerView)
        if let componentDetailView = componentDetailView {
            animatedContainerView.addSubview(componentDetailView)

            // Card fills inside animated container view
            componentDetailView.edges(to: animatedContainerView)

            animatedContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            let animatedContainerTopConstraint = animatedContainerView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0)
            let animatedContainerWidthConstraint = animatedContainerView.widthAnchor.constraint(equalToConstant: componentDetailView.frame.width)
            let animatedContainerHeightConstraint = animatedContainerView.heightAnchor.constraint(equalToConstant: componentDetailView.frame.height)

            NSLayoutConstraint.activate([animatedContainerTopConstraint, animatedContainerWidthConstraint, animatedContainerHeightConstraint])

            // Fix weird top inset
            let topTemporaryFix = screens.cardDetail?.componentContentView.topAnchor.constraint(equalTo: componentDetailView.topAnchor)
            topTemporaryFix?.isActive = GlobalConstants.isEnabledWeirdTopInsetsFix
            container.layoutIfNeeded()

            // Force card filling bottom
            let stretchCardToFillBottom = screens.cardDetail?.componentContentView.bottomAnchor.constraint(equalTo: componentDetailView.bottomAnchor)

            func animateCardViewBackToPlace() {
                stretchCardToFillBottom?.isActive = true
                //            screens.cardDetail.isFontStateHighlighted = false
                // Back to identity
                // NOTE: Animated container view in a way, helps us to not messing up `transform` with `AutoLayout` animation.
                componentDetailView.transform = CGAffineTransform.identity
                animatedContainerTopConstraint.constant = self.params.fromComponentWithoutTransform.minY
                animatedContainerWidthConstraint.constant = self.params.fromComponentWithoutTransform.width
                animatedContainerHeightConstraint.constant = self.params.fromComponentWithoutTransform.height
                container.layoutIfNeeded()
            }

            func completeEverything() {
                let success = !ctx.transitionWasCancelled
                animatedContainerView.removeConstraints(animatedContainerView.constraints)
                animatedContainerView.removeFromSuperview()
                if success {
                    componentDetailView.removeFromSuperview()
                    self.params.fromCell.isHidden = false
                } else {
                    //                screens.cardDetail.isFontStateHighlighted = true

                    // Remove temporary fixes if not success!
                    topTemporaryFix?.isActive = false
                    stretchCardToFillBottom?.isActive = false
//                    componentDetailView.removeConstraints([topTemporaryFix, componentWidthConstraint, componentHeightConstraint])
                    componentDetailView.removeConstraint(topTemporaryFix ?? NSLayoutConstraint())
                    componentDetailView.removeConstraint(stretchCardToFillBottom ?? NSLayoutConstraint())
                    container.removeConstraints(container.constraints)
                    container.addSubview(componentDetailView)
                    componentDetailView.edges(to: container)
                }
                ctx.completeTransition(success)
            }

            UIView.animate(withDuration: transitionDuration(using: ctx), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                animateCardViewBackToPlace()
            }) { (finished) in
                completeEverything()
            }

            UIView.animate(withDuration: transitionDuration(using: ctx) * 0.6) {
                screens.cardDetail?.scrollView.contentOffset = .zero
            }
        }
    }
}
