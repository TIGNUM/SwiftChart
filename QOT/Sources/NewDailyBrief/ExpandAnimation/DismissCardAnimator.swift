//
//  DismissCardAnimator.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 11/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class DismissCardAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    struct Params {
        let fromCardFrame: CGRect
        let fromCardFrameWithoutTransform: CGRect
        let fromCell: NewDailyStandardBriefCollectionViewCell
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

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return GlobalConstants.dismissalAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let ctx = transitionContext
        let container = ctx.containerView

        guard let fromVC = ctx.viewController(forKey: .from)?.children.first as? BaseDailyBriefDetailsViewController,
              let toVC = (ctx.viewController(forKey: .to) as? UINavigationController)?.topViewController?.children.first?.children.last?.children.first as? DailyBriefViewController
        else {
            return
        }

        let screens: (cardDetail: BaseDailyBriefDetailsViewController, home: DailyBriefViewController) = (fromVC, toVC)
        guard let cardDetailView = fromVC.tableView else {
            return
        }

        let animatedContainerView = UIView()
        if GlobalConstants.isEnabledDebugAnimatingViews {
            animatedContainerView.layer.borderColor = UIColor.yellow.cgColor
            animatedContainerView.layer.borderWidth = 4
            cardDetailView.layer.borderColor = UIColor.red.cgColor
            cardDetailView.layer.borderWidth = 2
        } else {
            animatedContainerView.layer.borderWidth = 0.5
            animatedContainerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(1).cgColor
        }

        animatedContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardDetailView.translatesAutoresizingMaskIntoConstraints = false

        container.removeConstraints(container.constraints)

        container.addSubview(animatedContainerView)
        animatedContainerView.addSubview(cardDetailView)

        // Card fills inside animated container view
        cardDetailView.edges(to: animatedContainerView)

        let safeGuide = container.safeAreaLayoutGuide

        animatedContainerView.centerXAnchor.constraint(equalTo: safeGuide.centerXAnchor).isActive = true
        let animatedContainerTopConstraint = animatedContainerView.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 0)
        let animatedContainerWidthConstraint = animatedContainerView.widthAnchor.constraint(equalToConstant: cardDetailView.frame.width)
        let animatedContainerHeightConstraint = animatedContainerView.heightAnchor.constraint(equalToConstant: cardDetailView.frame.height)

        NSLayoutConstraint.activate([animatedContainerTopConstraint, animatedContainerWidthConstraint, animatedContainerHeightConstraint])

        // Fix weird top inset
        let topTemporaryFix = screens.cardDetail.tableView.topAnchor.constraint(equalTo: cardDetailView.topAnchor)
        topTemporaryFix.isActive = GlobalConstants.isEnabledWeirdTopInsetsFix

        container.layoutIfNeeded()

        // Force card filling bottom
        let stretchCardToFillBottom = screens.cardDetail.tableView.bottomAnchor.constraint(equalTo: cardDetailView.bottomAnchor)

        params.fromCell.arrowButton.alpha = 0
        params.fromCell.body.alpha = 0

        func animateCardViewBackToPlace() {
            stretchCardToFillBottom.isActive = false
            // Back to identity
            // NOTE: Animated container view in a way, helps us to not messing up `transform` with `AutoLayout` animation.
            cardDetailView.transform = CGAffineTransform.identity
            animatedContainerTopConstraint.constant = self.params.fromCardFrameWithoutTransform.minY
            animatedContainerWidthConstraint.constant = self.params.fromCardFrameWithoutTransform.width
            animatedContainerHeightConstraint.constant = self.params.fromCardFrameWithoutTransform.height

            container.layoutIfNeeded()
        }

        func completeEverything() {
            let success = !ctx.transitionWasCancelled
            if success {
                self.params.fromCell.isHidden = false
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.params.fromCell.arrowButton.alpha = 1
                    self?.params.fromCell.body.alpha = 1
                } completion: { _ in
                    animatedContainerView.removeConstraints(animatedContainerView.constraints)
                    animatedContainerView.removeFromSuperview()
                    cardDetailView.removeFromSuperview()
                }
            } else {
                stretchCardToFillBottom.isActive = false
                cardDetailView.removeConstraint(stretchCardToFillBottom)
                container.removeConstraints(container.constraints)

                container.addSubview(cardDetailView)
                cardDetailView.edges(to: container)
            }
            ctx.completeTransition(success)
        }
        
        UIView.animate(withDuration: transitionDuration(using: ctx), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            animateCardViewBackToPlace()
        }) { _ in
            completeEverything()
        }

        UIView.animate(withDuration: transitionDuration(using: ctx) * 0.6) {
            screens.cardDetail.tableView.contentOffset = .zero
        }
    }
}
