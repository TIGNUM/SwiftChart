//
//  SkeletonDailyCheckInFooter.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonDailyCheckInFooter: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonDailyCheckInFooter {
        guard let objectView = R.nib.skeletonDailyCheckInFooter.instantiate(withOwner: self).first as? SkeletonDailyCheckInFooter else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
