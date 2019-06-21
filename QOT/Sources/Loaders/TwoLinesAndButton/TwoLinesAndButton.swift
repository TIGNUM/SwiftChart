//
//  TwoLinesAndButton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class TwoLinesAndButton: UIView {

    @IBOutlet private weak var containerView: UIView!

    static func instantiateFromNib() -> TwoLinesAndButton {
        guard let twoLinesAndButton = R.nib.twoLinesAndButton.instantiate(withOwner: self).first as? TwoLinesAndButton else {
            fatalError("Cannot load view")
        }
        return twoLinesAndButton
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
