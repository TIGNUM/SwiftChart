//
//  SkeletonThreeLinesLeftColumn.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonThreeLinesLeftColumn: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonThreeLinesLeftColumn {
        guard let objectView = R.nib.skeletonThreeLinesLeftColumn.instantiate(withOwner: self).first as? SkeletonThreeLinesLeftColumn else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
