//
//  MyToBeVisionAnimation.swift
//  QOT
//
//  Created by Moucheg Mouradian on 19/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MyToBeVisionAnimation: NSObject {

    fileprivate let isPresenting: Bool
    fileprivate let duration: TimeInterval

    init(isPresenting: Bool, duration: TimeInterval) {
        self.isPresenting = isPresenting
        self.duration = duration
        super.init()
    }
    
    private func getMyUniverseViewController(_ viewController: UIViewController) -> MyUniverseViewController? {
        if let viewController = viewController as? TabBarController, viewController.viewControllers.count > 1, let childViewController = viewController.viewControllers[1] as? MyUniverseViewController {
            return childViewController
        }
        return nil
    }
    
    private func getMyToBeVisionViewController(_ viewController: UIViewController) -> MyToBeVisionViewController? {
        if let viewController = viewController as? MyToBeVisionViewController {
            return viewController
        }
        return nil
    }
    
    private func prepare(_ myUniverseViewController: MyUniverseViewController, _ myToBeVisionViewController: MyToBeVisionViewController) {
        if isPresenting {
            myToBeVisionViewController.view.alpha = 0
        } else {
            myUniverseViewController.view.alpha = 0
        }
    }
    
    private func animate(_ myUniverseViewController: MyUniverseViewController, _ myToBeVisionViewController: MyToBeVisionViewController) {
        if isPresenting {
            myToBeVisionViewController.view.alpha = 1
            myUniverseViewController.myDataView.profileImageButton.transform = CGAffineTransform(translationX: 90.0, y: 260.0).scaledBy(x: 4.0, y: 3.0)
            myUniverseViewController.myWhyView.myToBeVisionBox.transform = CGAffineTransform(translationX: -120.0, y: 20.0)
            myUniverseViewController.myWhyView.weeklyChoicesBox.transform = CGAffineTransform(translationX: 100.0, y: 10.0)
            myUniverseViewController.myWhyView.qotPartnersBox.transform = CGAffineTransform(translationX: 10.0, y: 100.0)
            myUniverseViewController.view.alpha = 0
        } else {
            myToBeVisionViewController.view.alpha = 0
            myUniverseViewController.myDataView.profileImageButton.transform = .identity
            myUniverseViewController.myWhyView.myToBeVisionBox.transform = .identity
            myUniverseViewController.myWhyView.weeklyChoicesBox.transform = .identity
            myUniverseViewController.myWhyView.qotPartnersBox.transform = .identity
            myUniverseViewController.view.alpha = 1
        }
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension MyToBeVisionAnimation: UIViewControllerAnimatedTransitioning {

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
        let expectedMyToBeVisionViewController = isPresenting ? toViewController : fromViewController
        guard
            let myUniverseViewController = getMyUniverseViewController(expectedMyUniverseViewController),
            let myToBeVisionViewController = getMyToBeVisionViewController(expectedMyToBeVisionViewController) else {
                fatalError("missing view controllers for animation")
        }
        
        prepare(myUniverseViewController, myToBeVisionViewController)
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            self.animate(myUniverseViewController, myToBeVisionViewController)
        }, completion: { finished in
            if finished {
                fromViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
            }
            transitionContext.completeTransition(finished)
        })
    }
}
