//
//  LinesAndImageSkeleton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class ThreeLines: UIView {

    @IBOutlet private weak var containerView: UIView!

    static func instantiateFromNib() -> ThreeLines {
        guard let threeLines = R.nib.threeLines.instantiate(withOwner: self).first as? ThreeLines else {
            fatalError("Cannot load view")
        }
        return threeLines
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        startAnimating()
    }

    private func startAnimating() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.autoreverse, .repeat],
                       animations: {
                        self.containerView.alpha = 0.0 },
                       completion: nil)
    }
}
