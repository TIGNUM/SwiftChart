//
//  SkeletonFiveLinesWithTopBroad.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonFiveLinesWithTopBroad: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonFiveLinesWithTopBroad {
        guard let objectView = R.nib.skeletonFiveLinesWithTopBroad.instantiate(withOwner: self).first as? SkeletonFiveLinesWithTopBroad else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
