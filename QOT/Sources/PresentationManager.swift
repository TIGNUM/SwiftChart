//
//  PresentationManager.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

enum PresentationType {
    case fadeIn
    case fadeOut
}

final class PresentationManager: NSObject {

    var presentationType = PresentationType.fadeIn
}

extension PresentationManager: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return FadeInOutPresentationController(presentedViewController: presented, presenting: presenting, presentationType: presentationType)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInOutPresentationAnimator(presentationType: presentationType, isPresentation: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInOutPresentationAnimator(presentationType: presentationType, isPresentation: false)
    }
}
