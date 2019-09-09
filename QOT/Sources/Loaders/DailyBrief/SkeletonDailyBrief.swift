//
//  SkeletonDailyBrief.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonDailyBrief: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonDailyBrief {
        guard let objectView = R.nib.skeletonDailyBrief.instantiate(withOwner: self).first as? SkeletonDailyBrief else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
