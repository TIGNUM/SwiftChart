//
//  SkeletonPadHeading.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonPadHeading: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonPadHeading {
        guard let objectView = R.nib.skeletonPadHeading.instantiate(withOwner: self).first as? SkeletonPadHeading else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
