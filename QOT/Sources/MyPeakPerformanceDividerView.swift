//
//  MyPeakPerformanceDividerView.swift
//  QOT
//
//  Created by Srikanth Roopa on 14.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyPeakPerformanceDividerView: UIView {

    @IBOutlet weak var footerView: UIView!
    static func instantiateFromNib() -> MyPeakPerformanceDividerView? {
        guard let section = R.nib.myPeakPerformanceDividerView
            .instantiate(withOwner: self).first as? MyPeakPerformanceDividerView else {
                preconditionFailure("Cannot load view \(#function)")
        }
        return section
    }
}
