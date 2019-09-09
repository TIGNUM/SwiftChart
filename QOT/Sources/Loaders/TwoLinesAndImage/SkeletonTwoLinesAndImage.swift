//
//  SkeletonTwoLinesAndImage.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonTwoLinesAndImage: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonTwoLinesAndImage {
        guard let objectView = R.nib.skeletonTwoLinesAndImage.instantiate(withOwner: self).first as? SkeletonTwoLinesAndImage else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
