//
//  JustLinesSkeleton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class OneLineHeading: BaseSkeletonView {

    static func instantiateFromNib() -> OneLineHeading {
        guard let objectView = R.nib.oneLineHeading.instantiate(withOwner: self).first as? OneLineHeading else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
