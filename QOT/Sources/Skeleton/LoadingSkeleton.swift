//
//  LoadingSkeleton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class LoadingSkeleton: UIView {

    func showLoaderSkeleton() {
        showSkeleton(with: .loader)
    }

    func showSkeleton(with type: SkeletonType = .loader, delay: Double = 0.0) {
        let objectView = type.objectView
        self.addSubview(objectView)
        objectView.startAnimating(delay)
        objectView.addConstraints(to: self)
    }
}
