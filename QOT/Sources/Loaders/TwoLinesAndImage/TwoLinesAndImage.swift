//
//  TwoLinesAndImage.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class TwoLinesAndImage: UIView {

    @IBOutlet private weak var containerView: UIView!

    static func instantiateFromNib() -> TwoLinesAndImage {
        guard let twoLinesAndImage = R.nib.twoLinesAndImage.instantiate(withOwner: self).first as? TwoLinesAndImage else {
            fatalError("Cannot load view")
        }
        return twoLinesAndImage
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
