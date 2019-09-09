//
//  SkeletonLoader.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonLoader: SkeletonBaseView {

    @IBOutlet private weak var loader: UIActivityIndicatorView!

    static func instantiateFromNib() -> SkeletonLoader {
        guard let objectView = R.nib.skeletonLoader.instantiate(withOwner: self).first as? SkeletonLoader else {
            fatalError("Cannot load view")
        }
        return objectView
    }

    override func startAnimating(_ delay: Double) {
        loader.startAnimating()
    }
}
