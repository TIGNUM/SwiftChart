//
//  LinesAndImageSkeleton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class ThreeLinesTwoColumns: BaseSkeletonView {

    static func instantiateFromNib() -> ThreeLinesTwoColumns {
        guard let objectView = R.nib.threeLinesTwoColumns.instantiate(withOwner: self).first as? ThreeLinesTwoColumns else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
