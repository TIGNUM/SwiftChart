//
//  ThreeLinesAndButton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class ThreeLinesAndButton: UIView {

    @IBOutlet private weak var containerView: UIView!

    static func instantiateFromNib() -> ThreeLinesAndButton {
        guard let threeLinesAndButton = R.nib.threeLinesAndButton.instantiate(withOwner: self).first as? ThreeLinesAndButton else {
            fatalError("Cannot load view")
        }
        return threeLinesAndButton
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
