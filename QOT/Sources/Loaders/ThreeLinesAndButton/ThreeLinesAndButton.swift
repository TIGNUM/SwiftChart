//
//  ThreeLinesAndButton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class ThreeLinesAndButton: BaseSkeletonView {

    static func instantiateFromNib() -> ThreeLinesAndButton {
        guard let objectView = R.nib.threeLinesAndButton.instantiate(withOwner: self).first as? ThreeLinesAndButton else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
