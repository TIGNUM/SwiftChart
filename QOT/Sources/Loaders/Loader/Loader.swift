//
//  Loader.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class Loader: UIView {

    @IBOutlet private weak var loader: UIActivityIndicatorView!

    static func instantiateFromNib() -> Loader {
        guard let loader = R.nib.loader.instantiate(withOwner: self).first as? Loader else {
            fatalError("Cannot load view")
        }
        return loader
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        startLoading()
    }

    private func startLoading() {
        loader.startAnimating()
    }
}
