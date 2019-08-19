//
//  LinesAndImageSkeleton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class ThreeLinesLeftColumn: BaseSkeletonView {

    static func instantiateFromNib() -> ThreeLinesLeftColumn {
        guard let objectView = R.nib.threeLinesLeftColumn.instantiate(withOwner: self).first as? ThreeLinesLeftColumn else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
