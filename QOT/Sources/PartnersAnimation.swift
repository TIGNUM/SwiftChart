//
//  PartnersAnimation.swift
//  QOT
//
//  Created by Moucheg Mouradian on 19/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class PartnersAnimation: NSObject {

    private let isPresenting: Bool
    private let duration: TimeInterval

    init(isPresenting: Bool, duration: TimeInterval) {
        self.isPresenting = isPresenting
        self.duration = duration
        super.init()
    }

    private func getMyUniverseViewController(_ viewController: UIViewController) -> MyUniverseViewController? {
        if let viewController = viewController as? TabBarController, let viewControllers = viewController.viewControllers, viewControllers.count > 1, let childViewController = viewControllers[1] as? MyUniverseViewController {
            return childViewController
        }
        return nil
    }

    private func getPartnersViewController(_ viewController: UIViewController) -> PartnersViewController? {
        if let navigationController = viewController as? UINavigationController, let pageViewController = navigationController.viewControllers.first as? PageViewController, let childViewController = pageViewController.viewControllers?.first as? PartnersViewController {
            return childViewController
        }
        return nil
    }

    private func prepare(_ myUniverseViewController: MyUniverseViewController, _ partnersViewController: PartnersViewController) {
        if isPresenting {
            partnersViewController.navigationController?.view.alpha = 0
        } else {
            myUniverseViewController.myWhyView.qotPartnersBox.transform = CGAffineTransform(translationX: 200.0, y: -300.0).scaledBy(x: 2.5, y: 2.5)
            myUniverseViewController.view.alpha = 0
        }
    }

    private func animate(_ myUniverseViewController: MyUniverseViewController, _ partnersViewController: PartnersViewController) {
        if isPresenting {
            partnersViewController.navigationController?.view.alpha = 1
            myUniverseViewController.myWhyView.qotPartnersBox.transform = CGAffineTransform(translationX: 200.0, y: -300.0).scaledBy(x: 2.5, y: 2.5)
        } else {
            partnersViewController.navigationController?.view.alpha = 0
            myUniverseViewController.myWhyView.qotPartnersBox.transform = .identity
            myUniverseViewController.view.alpha = 1
            partnersViewController.scrollView.transform = CGAffineTransform(translationX: 0.0, y: 100.0)
        }
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension PartnersAnimation: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
        }

        fromViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)

        if isPresenting {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            toViewController.view.frame = containerView.bounds
        }

        let expectedMyUniverseViewController = isPresenting ? fromViewController : toViewController
        let expectedPartnersViewController = isPresenting ? toViewController : fromViewController
        guard
            let myUniverseViewController = getMyUniverseViewController(expectedMyUniverseViewController),
            let partnersViewController = getPartnersViewController(expectedPartnersViewController) else {
                fatalError("missing view controllers for animation")
        }

        prepare(myUniverseViewController, partnersViewController)

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            self.animate(myUniverseViewController, partnersViewController)
        }, completion: { finished in
            if finished {
                fromViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
            }
            transitionContext.completeTransition(finished)
        })
    }
}
