//
//  SkeletonDailyCheckInHeader.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonDailyCheckInHeader: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonDailyCheckInHeader {
        guard let objectView = R.nib.skeletonDailyCheckInHeader.instantiate(withOwner: self).first as? SkeletonDailyCheckInHeader else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
