//
//  FadeInOutPresentationAnimator.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class FadeInOutPresentationAnimator: NSObject {

    let presentationType: PresentationType
    let isPresentation: Bool
    fileprivate(set) var fromViewController: UIViewController?
    fileprivate(set) var toViewController: UIViewController?

    init(presentationType: PresentationType, isPresentation: Bool) {
        self.presentationType = presentationType
        self.isPresentation = isPresentation

        super.init()
    }
}

extension FadeInOutPresentationAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Animation.durationFade
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key = isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        let controller = transitionContext.viewController(forKey: key)!

        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }
        self.fromViewController = fromViewController
        self.toViewController = toViewController

        toViewController.beginAppearanceTransition(true, animated: true)
        fromViewController.beginAppearanceTransition(false, animated: false)

        if isPresentation == true {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        
        switch presentationType {
        case .fadeIn:   dismissedFrame.origin.y = Animation.fadeInHeight
        case .fadeOut:  dismissedFrame.origin.y = Animation.fadeOutHeight
        }
        
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        
        UIView.animate(withDuration: animationDuration, animations: {
            controller.view.frame = finalFrame
        }) { [unowned self] (finished: Bool) in
            if finished {
                self.toViewController?.endAppearanceTransition()
                self.fromViewController?.endAppearanceTransition()
            }
            transitionContext.completeTransition(finished)
        }
    }
}
