//
//  SkeletonThreeLinesAndTwoColumns.swift
//  QOT
//
//  Created by Srikanth Roopa on 20.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class SkeletonThreeLinesAndTwoColumns: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonThreeLinesAndTwoColumns {
        guard let view = R.nib.skeletonThreeLinesAndTwoColumns.instantiate(withOwner: self).first as? SkeletonThreeLinesAndTwoColumns else {
            fatalError("Cannot load view")
        }
        return view
    }
}
