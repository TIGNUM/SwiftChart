//
//  LoaderSkeleton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class DailyCheckInHeader: BaseSkeletonView {

    static func instantiateFromNib() -> DailyCheckInHeader {
        guard let objectView = R.nib.dailyCheckInHeader.instantiate(withOwner: self).first as? DailyCheckInHeader else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
