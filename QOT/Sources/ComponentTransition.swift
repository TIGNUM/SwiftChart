//
//  ComponentTransition.swift
//  QOT
//
//  Created by karmic on 25.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ComponentTransition: NSObject {
    struct Params {
        let fromComponentFrame: CGRect
        let fromComponentFrameWithoutTransform: CGRect
        let fromCell: ComponentCollectionViewCell
    }

    let params: Params

    init(params: Params) {
        self.params = params
        super.init()
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension ComponentTransition: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let params = PresentComponentAnimator.Params(
            fromComponentFrame: self.params.fromComponentFrame,
            fromCell: self.params.fromCell)
        return PresentComponentAnimator(params: params)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let params = DismissComponentAnimator.Params(
            fromComponentFrame: self.params.fromComponentFrame,
            fromComponentWithoutTransform: self.params.fromComponentFrameWithoutTransform,
            fromCell: self.params.fromCell)
        return DismissComponentAnimator(params: params)
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ComponentPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
