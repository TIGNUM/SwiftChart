//
//  SkeletonDailyCheckInRow.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonDailyCheckInRow: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonDailyCheckInRow {
        guard let objectView = R.nib.skeletonDailyCheckInRow.instantiate(withOwner: self).first as? SkeletonDailyCheckInRow else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
