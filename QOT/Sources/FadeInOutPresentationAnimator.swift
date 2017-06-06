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
        }) { (finished: Bool) in
            transitionContext.completeTransition(finished)
        }
    }
}
