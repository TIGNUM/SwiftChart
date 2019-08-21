//
//  PadHeading.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class PadHeading: BaseSkeletonView {

    static func instantiateFromNib() -> PadHeading {
        guard let objectView = R.nib.padHeading.instantiate(withOwner: self).first as? PadHeading else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
