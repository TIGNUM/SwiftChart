//
//  CardPresentationController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 11/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class CardPresentationController: UIPresentationController {

    private lazy var blurView = UIVisualEffectView(effect: nil)

    // Default is false.
    // And also means you can access only `.to` when present, and `.from` when dismiss (e.g., can touch only 'presented view').
    //
    // If true, the presenting view is removed and you have to add it during animation accessing `.from` key.
    // And you will have access to both `.to` and `.from` view. (In the typical .fullScreen mode)
    override var shouldRemovePresentersView: Bool {
        return false
    }

    override func presentationTransitionWillBegin() {
        let container = containerView!
        blurView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(blurView)
        blurView.edges(to: container)
        blurView.alpha = 0.0

        presentingViewController.beginAppearanceTransition(false, animated: false)
        presentedViewController.transitionCoordinator!.animate(alongsideTransition: { [weak self] (ctx) in
            guard let strongSelf = self else { return }
            UIView.animate(withDuration: 0.5, animations: {
                strongSelf.blurView.effect = UIBlurEffect(style: .dark)
                strongSelf.blurView.alpha = 1
            })
        }, completion: { (ctx) in })
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        presentingViewController.endAppearanceTransition()
    }

    override func dismissalTransitionWillBegin() {
        presentingViewController.beginAppearanceTransition(true, animated: true)
        presentedViewController.transitionCoordinator!.animate(alongsideTransition: { [weak self] (ctx) in
            guard let strongSelf = self else { return }
            strongSelf.blurView.alpha = 0.0
        }, completion: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        presentingViewController.endAppearanceTransition()
        if completed {
            blurView.removeFromSuperview()
        }
    }
}
