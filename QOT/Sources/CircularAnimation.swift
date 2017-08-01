//
//  CircularAnimation.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 7/12/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

enum ZoomType {
    case presenting, dismissing
}

final class CircularAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval
    var isPresenting: Bool
    var originFrame: CGRect

    fileprivate var fromViewController: UIViewController?
    fileprivate var toViewController: UIViewController?
    fileprivate var transitionContext: UIViewControllerContextTransitioning?

    init(withDuration duration: TimeInterval = 0.6, forTransitionType type: ZoomType, originFrame: CGRect) {
        self.duration = duration
        self.isPresenting = type == .presenting
        self.originFrame = originFrame

        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext

        let containerView = transitionContext.containerView
        fromViewController = transitionContext.viewController(forKey: .from)
        toViewController = transitionContext.viewController(forKey: .to)

        guard let fromViewController = fromViewController, let toViewController = toViewController else {
            self.transitionContext?.completeTransition(true)
            return
        }

        let animatedViewController = isPresenting ? toViewController : fromViewController
        let animatedView = animatedViewController.view!

        let bubbleView = UIView(frame: animatedView.frame)

        fromViewController.beginAppearanceTransition(false, animated: true)
        toViewController.beginAppearanceTransition(true, animated: true)

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
            bubbleAnimation(bubbleView: bubbleView, animatedView: animatedView, maskLayer: maskLayer, maskPath: maskPath, endFrame: endFrame)
        } else {
            contentAnimation(bubbleView: bubbleView, animatedView: animatedView, maskLayer: maskLayer, maskPath: maskPath, endFrame: endFrame)
        }
    }
}

// MARK: - private

private extension CircularAnimation {

    func animationsCompleted(bubbleView: UIView) {
        bubbleView.removeFromSuperview()
        self.transitionContext?.completeTransition(true)
        self.fromViewController?.endAppearanceTransition()
        self.toViewController?.endAppearanceTransition()
    }

    func contentAnimation(bubbleView: UIView, animatedView: UIView, maskLayer: CAShapeLayer, maskPath: UIBezierPath, endFrame: CGRect) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({ [unowned self] in
            if self.isPresenting {
                self.animationsCompleted(bubbleView: bubbleView)
            } else {
                animatedView.layer.opacity = 0
                self.bubbleAnimation(bubbleView: bubbleView, animatedView: animatedView, maskLayer: maskLayer, maskPath: maskPath, endFrame: endFrame)
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

    func bubbleAnimation(bubbleView: UIView, animatedView: UIView, maskLayer: CAShapeLayer, maskPath: UIBezierPath, endFrame: CGRect) {
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
