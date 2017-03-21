//
//  FadeInOutPresentationAnimator.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class FadeInOutPresentationAnimator: NSObject {

    let presentationType: PresentationType
    let isPresentation: Bool
    
    init(presentationType: PresentationType, isPresentation: Bool) {
        self.presentationType = presentationType
        self.isPresentation = isPresentation
        super.init()
    }
}

extension FadeInOutPresentationAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key = isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        let controller = transitionContext.viewController(forKey: key)!
        
        if (isPresentation == true) {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        
        switch presentationType {
        case .fadeIn:   dismissedFrame.origin.x = -presentedFrame.width
        case .fadeOut:  dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
        }
        
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        
        UIView.animate(withDuration: animationDuration, animations: {
            controller.view.frame = finalFrame
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}
