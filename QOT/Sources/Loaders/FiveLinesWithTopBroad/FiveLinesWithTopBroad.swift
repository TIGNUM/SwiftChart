//
//  LoaderSkeleton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class FiveLinesWithTopBroad: UIView {

    @IBOutlet private weak var containerView: UIView!

    static func instantiateFromNib() -> FiveLinesWithTopBroad {
        guard let fiveLinesWithTopBroad = R.nib.fiveLinesWithTopBroad.instantiate(withOwner: self).first as? FiveLinesWithTopBroad else {
            fatalError("Cannot load view")
        }
        return fiveLinesWithTopBroad
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        startAnimating()
    }

    func startAnimating() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.autoreverse, .repeat],
                       animations: {
                        self.containerView.alpha = 0.0 },
                       completion: nil)
    }
}
