//
//  FadeInOutPresentationControllery.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

enum TransitionType {
    case presentation
    case dismissal
    
    var alphaValues: (containerViewStart: CGFloat, containerViewEnd: CGFloat, presentingView: CGFloat) {
        switch self {
        case .presentation: return (0, 1, 0)
        case .dismissal: return (1, 0, 1)
        }
    }
}

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
        manageTransition(transitionType: .presentation)
    }

    override func dismissalTransitionWillBegin() {
        manageTransition(transitionType: .dismissal)
    }
    
    private func manageTransition(transitionType: TransitionType) {
        containerView?.alpha = transitionType.alphaValues.containerViewStart
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            return
        }
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.containerView?.alpha = transitionType.alphaValues.containerViewEnd
            self?.presentingViewController.view.alpha = transitionType.alphaValues.presentingView
        })
    }
}
