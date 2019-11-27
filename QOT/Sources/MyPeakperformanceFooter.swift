//
//  MyPeakperformanceFooter.swift
//  QOT
//
//  Created by Srikanth Roopa on 13.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyPeakPerformanceFooter: UIView {

    static func instantiateFromNib() -> MyPeakPerformanceFooter? {
        guard let section = R.nib.myPeakPerformanceFooter
            .instantiate(withOwner: self).first as? MyPeakPerformanceFooter else {
                preconditionFailure("Cannot load view \(#function)")
        }
        return section
    }
}
