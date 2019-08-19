//
//  LoaderSkeleton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class FiveLinesWithTopBroad: BaseSkeletonView {

    static func instantiateFromNib() -> FiveLinesWithTopBroad {
        guard let objectView = R.nib.fiveLinesWithTopBroad.instantiate(withOwner: self).first as? FiveLinesWithTopBroad else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
