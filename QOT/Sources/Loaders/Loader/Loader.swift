//
//  Loader.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class Loader: BaseSkeletonView {

    @IBOutlet private weak var loader: UIActivityIndicatorView!

    static func instantiateFromNib() -> Loader {
        guard let objectView = R.nib.loader.instantiate(withOwner: self).first as? Loader else {
            fatalError("Cannot load view")
        }
        return objectView
    }

    override func startAnimating(_ delay: Double) {
        loader.startAnimating()
    }
}
