//
//  ZoomPresentationManager.swift
//  QOT
//
//  Created by Moucheg Mouradian on 25/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ZoomPresentationManager: NSObject {

    var openingFrame: CGRect

    init(openingFrame: CGRect) {
        self.openingFrame = openingFrame

        super.init()
    }
}

extension ZoomPresentationManager: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ZoomPresentationController(presentedViewController: presented, presenting: presenting, openingFrame: openingFrame)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomAnimator(isPresentating: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomAnimator(isPresentating: false)
    }
}
