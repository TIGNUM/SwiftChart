//
//  LoaderSkeleton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class DailyCheckInRow: BaseSkeletonView {

    static func instantiateFromNib() -> DailyCheckInRow {
        guard let objectView = R.nib.dailyCheckInRow.instantiate(withOwner: self).first as? DailyCheckInRow else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
