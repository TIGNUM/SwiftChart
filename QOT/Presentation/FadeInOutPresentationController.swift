//
//  FadeInOutPresentationControllery.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class FadeInOutPresentationController: UIPresentationController {

    private var presentationType = PresentationType.fadeIn
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, presentationType: PresentationType) {
        self.presentationType = presentationType
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        // TODO some nice animations
    }
    
    override func dismissalTransitionWillBegin() {
        // TODO some nice animations
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        switch presentationType {
        case .fadeIn:   return CGSize(width: parentSize.width*(2.0/3.0), height: parentSize.height)
        case .fadeOut:  return CGSize(width: parentSize.width, height: parentSize.height*(2.0/3.0))
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
        
        switch presentationType {
        case .fadeIn:   frame.origin.x = containerView!.frame.width*(1.0/3.0)
        case .fadeOut:  frame.origin.y = containerView!.frame.height*(1.0/3.0)
        }
        
        return frame
    }
}
