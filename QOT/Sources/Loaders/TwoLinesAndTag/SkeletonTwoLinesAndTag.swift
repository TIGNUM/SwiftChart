//
//  SkeletonTwoLinesAndTag.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonTwoLinesAndTag: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonTwoLinesAndTag {
        guard let objectView = R.nib.skeletonTwoLinesAndTag.instantiate(withOwner: self).first as? SkeletonTwoLinesAndTag else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
