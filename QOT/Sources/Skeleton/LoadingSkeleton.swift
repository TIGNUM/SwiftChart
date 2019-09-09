//
//  LoadingSkeleton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class LoadingSkeleton: UIView {

    func showLoaderSkeleton(backgroundColor: UIColor? = UIColor.carbon) {
        showSkeleton(with: .loader, backgroundColor: backgroundColor)
    }

    func showSkeleton(with type: SkeletonType = .loader, delay: Double = 0.0, backgroundColor: UIColor? = .carbon) {
        let objectView = type.objectView
        objectView.containerView.backgroundColor = backgroundColor
        self.backgroundColor = backgroundColor
        self.addSubview(objectView)
        objectView.startAnimating(delay)
        objectView.addConstraints(to: self)
    }
}
