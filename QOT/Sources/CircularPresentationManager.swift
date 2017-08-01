//
//  CircularPresentationManager.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 7/14/17.
//  Copyright © 2017 Tignum. All rights reserved.
//
//
import Foundation
import UIKit

enum ZoomPresentationType {
    case zoomIn
    case zoomOut
}

final class CircularPresentationManager: NSObject {
    fileprivate var originFrame: CGRect

    init(originFrame: CGRect) {
        self.originFrame = originFrame
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension CircularPresentationManager: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircularAnimation(forTransitionType: .presenting, originFrame: originFrame)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircularAnimation(forTransitionType: .dismissing, originFrame: originFrame)
    }
}
