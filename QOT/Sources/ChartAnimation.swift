//
//  ChartAnimation.swift
//  QOT
//
//  Created by Moucheg Mouradian on 19/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ChartAnimation: NSObject {

    private let isPresenting: Bool
    private let duration: TimeInterval

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
    
    private func getChartViewController(_ viewController: UIViewController) -> ChartViewController? {
        if let navigationController = viewController as? UINavigationController, let pageViewController = navigationController.viewControllers.first as? PageViewController, let childViewController = pageViewController.viewControllers?.first as? ChartViewController {
            return childViewController
        }
        return nil
    }
    
    private func prepare(_ myUniverseViewController: MyUniverseViewController, _ chartViewController: ChartViewController) {
        if isPresenting {
            chartViewController.navigationController?.view.alpha = 0
        } else {
            myUniverseViewController.myDataView.profileImageButton.transform = CGAffineTransform(translationX: 300.0, y: 0)
            myUniverseViewController.view.transform = CGAffineTransform(scaleX: 3, y: 3)
            let layerTransform = myUniverseViewController.myDataView.universeDotsLayer.transform
            myUniverseViewController.myDataView.universeDotsLayer.transform = CATransform3DTranslate(layerTransform, -200, 0, 0)
            myUniverseViewController.view.alpha = 0
        }
    }
    
    private func animate(_ myUniverseViewController: MyUniverseViewController, _ chartViewController: ChartViewController) {
        if isPresenting {
            chartViewController.navigationController?.view.alpha = 1
            myUniverseViewController.myDataView.profileImageButton.transform = CGAffineTransform(translationX: 300.0, y: 0)
            myUniverseViewController.view.transform = CGAffineTransform(scaleX: 3, y: 3)
            let layerTransform = myUniverseViewController.myDataView.universeDotsLayer.transform
            myUniverseViewController.myDataView.universeDotsLayer.transform = CATransform3DTranslate(layerTransform, -200, 0, 0)
        } else {
            chartViewController.navigationController?.view.alpha = 0
            myUniverseViewController.myDataView.profileImageButton.transform = .identity
            myUniverseViewController.view.transform = .identity
            myUniverseViewController.myDataView.universeDotsLayer.transform = CATransform3DIdentity
            myUniverseViewController.view.alpha = 1
        }
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension ChartAnimation: UIViewControllerAnimatedTransitioning {

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
        let expectedChartViewController = isPresenting ? toViewController : fromViewController
        guard
            let myUniverseViewController = getMyUniverseViewController(expectedMyUniverseViewController),
            let chartViewController = getChartViewController(expectedChartViewController) else {
                fatalError("missing view controllers for animation")
        }
        
        prepare(myUniverseViewController, chartViewController)
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            self.animate(myUniverseViewController, chartViewController)
        }, completion: { finished in
            if finished {
                fromViewController.endAppearanceTransition()
                toViewController.endAppearanceTransition()
            }
            transitionContext.completeTransition(finished)
        })
    }
}
