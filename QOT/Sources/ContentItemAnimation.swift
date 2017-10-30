//
//  ContentItemAnimation.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 7/12/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class ContentItemAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval
    let isPresenting: Bool
    let originFrame: CGRect

    fileprivate var fromViewController: UIViewController?
    fileprivate var toViewController: UIViewController?
    fileprivate var transitionContext: UIViewControllerContextTransitioning?

    init(isPresenting: Bool, duration: TimeInterval, originFrame: CGRect) {
        self.isPresenting = isPresenting
        self.duration = duration
        self.originFrame = originFrame

        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {
            self.transitionContext?.completeTransition(true)
            return
        }
        self.fromViewController = fromViewController
        self.toViewController = toViewController
        
        fromViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)
        
        let animatedViewController = isPresenting ? toViewController : fromViewController
        let animatedView = animatedViewController.view!
        let bubbleView = UIView(frame: animatedView.frame)
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view!)
        containerView.addSubview(bubbleView)
        if !isPresenting {
            containerView.bringSubview(toFront: animatedView)
        }
        containerView.bringSubview(toFront: bubbleView)

        let bigHeight = animatedView.frame.height * 3
        let bigFrame = CGRect(x: animatedView.frame.origin.x - animatedView.frame.height,
                              y: animatedView.frame.origin.y - animatedView.frame.height,
                              width: bigHeight,
                              height: bigHeight)

        let startFrame = isPresenting ? originFrame : bigFrame
        let endFrame = isPresenting ? bigFrame : originFrame

        let maskPath = UIBezierPath(ovalIn: startFrame)
        let maskLayer = CAShapeLayer()
        maskLayer.opacity = 0
        maskLayer.frame = animatedView.frame
        maskLayer.path = maskPath.cgPath
        bubbleView.layer.mask = maskLayer

        animatedView.layer.opacity = self.isPresenting ? 0 : 1
        bubbleView.backgroundColor = .white

        if isPresenting {
            contentItemAnimation(bubbleView: bubbleView, animatedView: animatedView, maskLayer: maskLayer, maskPath: maskPath, endFrame: endFrame)
        } else {
            contentAnimation(bubbleView: bubbleView, animatedView: animatedView, maskLayer: maskLayer, maskPath: maskPath, endFrame: endFrame)
        }
    }
}

// MARK: - private

private extension ContentItemAnimation {

    func animationsCompleted(bubbleView: UIView) {
        bubbleView.removeFromSuperview()
        fromViewController?.endAppearanceTransition()
        toViewController?.endAppearanceTransition()
        transitionContext?.completeTransition(!(transitionContext?.transitionWasCancelled ?? false))
    }

    func contentAnimation(bubbleView: UIView, animatedView: UIView, maskLayer: CAShapeLayer, maskPath: UIBezierPath, endFrame: CGRect) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({ [unowned self] in
            if self.isPresenting {
                self.animationsCompleted(bubbleView: bubbleView)
            } else {
                animatedView.layer.opacity = 0
                self.contentItemAnimation(bubbleView: bubbleView, animatedView: animatedView, maskLayer: maskLayer, maskPath: maskPath, endFrame: endFrame)
            }
        })

        animatedView.layer.opacity = 1

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = self.isPresenting ? 1 : 0
        opacityAnimation.toValue = self.isPresenting ? 0 : 1
        opacityAnimation.fillMode = kCAFillModeForwards
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.duration = self.duration / 2
        maskLayer.add(opacityAnimation, forKey: "opacity")

        CATransaction.commit()
    }

    func contentItemAnimation(bubbleView: UIView, animatedView: UIView, maskLayer: CAShapeLayer, maskPath: UIBezierPath, endFrame: CGRect) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({ [unowned self] in
            if self.isPresenting {
                self.contentAnimation(bubbleView: bubbleView, animatedView: animatedView, maskLayer: maskLayer, maskPath: maskPath, endFrame: endFrame)
            } else {
                self.animationsCompleted(bubbleView: bubbleView)
            }
        })

        let endCirclePath = UIBezierPath(ovalIn: endFrame)

        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = maskPath.cgPath
        pathAnimation.toValue = endCirclePath
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.isRemovedOnCompletion = false
        pathAnimation.duration = duration / 2

        maskLayer.path = endCirclePath.cgPath
        maskLayer.add(pathAnimation, forKey: "pathAnimation")

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = isPresenting ? 0 : 1
        opacityAnimation.toValue = isPresenting ? 1 : 0
        opacityAnimation.fillMode = kCAFillModeForwards
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.duration = duration / 2
        maskLayer.add(opacityAnimation, forKey: "opacity")
        
        CATransaction.commit()
    }
}
