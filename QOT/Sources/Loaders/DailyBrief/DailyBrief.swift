//
//  DailyBrief.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class DailyBrief: BaseSkeletonView {

    static func instantiateFromNib() -> DailyBrief {
        guard let objectView = R.nib.dailyBrief.instantiate(withOwner: self).first as? DailyBrief else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
