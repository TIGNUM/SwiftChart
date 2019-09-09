//
//  SkeletonOneLineHeading.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonOneLineHeading: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonOneLineHeading {
        guard let objectView = R.nib.skeletonOneLineHeading.instantiate(withOwner: self).first as? SkeletonOneLineHeading else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
