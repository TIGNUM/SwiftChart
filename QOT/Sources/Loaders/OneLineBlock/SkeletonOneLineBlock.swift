//
//  SkeletonOneLineBlock.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonOneLineBlock: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonOneLineBlock {
        guard let objectView = R.nib.skeletonOneLineBlock.instantiate(withOwner: self).first as? SkeletonOneLineBlock else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
