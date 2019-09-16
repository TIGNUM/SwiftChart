//
//  MyPeakperformanceFooter.swift
//  QOT
//
//  Created by Srikanth Roopa on 13.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyPeakPerformanceFooter: UIView {

    @IBOutlet weak var footerView: UIView!
    static func instantiateFromNib() -> MyPeakPerformanceFooter? {
        guard let section = R.nib.myPeakPerformanceFooter
            .instantiate(withOwner: self).first as? MyPeakPerformanceFooter else {
                preconditionFailure("Cannot load view \(#function)")
        }
        return section
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        footerView.maskCorners(corners: [.bottomLeft, .bottomRight], radius: Layout.cornerRadius08)
    }
}
