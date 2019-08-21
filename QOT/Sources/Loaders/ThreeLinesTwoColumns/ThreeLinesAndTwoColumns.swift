//
//  ThreeLinesAndTwoColumns.swift
//  QOT
//
//  Created by Srikanth Roopa on 20.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class ThreeLinesAndTwoColumns: BaseSkeletonView {

    static func instantiateFromNib() -> ThreeLinesAndTwoColumns {
        guard let view = R.nib.threeLinesAndTwoColumns.instantiate(withOwner: self).first as? ThreeLinesAndTwoColumns else {
            fatalError("Cannot load view")
        }
        return view
    }
}
