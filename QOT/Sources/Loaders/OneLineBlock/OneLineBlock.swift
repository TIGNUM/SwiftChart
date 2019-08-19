//
//  JustLinesSkeleton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class OneLineBlock: BaseSkeletonView {

    static func instantiateFromNib() -> OneLineBlock {
        guard let objectView = R.nib.oneLineBlock.instantiate(withOwner: self).first as? OneLineBlock else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
