//
//  LoaderSkeleton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class DailyCheckInFooter: BaseSkeletonView {

    static func instantiateFromNib() -> DailyCheckInFooter {
        guard let objectView = R.nib.dailyCheckInFooter.instantiate(withOwner: self).first as? DailyCheckInFooter else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
