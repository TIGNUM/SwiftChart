//
//  ThreeLinesAndImage.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class ThreeLinesAndImage: BaseSkeletonView {

    static func instantiateFromNib() -> ThreeLinesAndImage {
        guard let objectView = R.nib.threeLinesAndImage.instantiate(withOwner: self).first as? ThreeLinesAndImage else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
