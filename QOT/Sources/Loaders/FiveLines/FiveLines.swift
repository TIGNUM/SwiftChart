//
//  JustLinesSkeleton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class FiveLines: BaseSkeletonView {

    static func instantiateFromNib() -> FiveLines {
        guard let objectView = R.nib.fiveLines.instantiate(withOwner: self).first as? FiveLines else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
