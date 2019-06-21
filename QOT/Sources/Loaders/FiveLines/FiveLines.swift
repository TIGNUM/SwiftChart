//
//  JustLinesSkeleton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class FiveLines: UIView {

    @IBOutlet private weak var containerView: UIView!

    static func instantiateFromNib() -> FiveLines {
        guard let fiveLines = R.nib.fiveLines.instantiate(withOwner: self).first as? FiveLines else {
            fatalError("Cannot load view")
        }
        return fiveLines
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
