//
//  TwoLinesAndTag.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class TwoLinesAndTag: BaseSkeletonView {

    static func instantiateFromNib() -> TwoLinesAndTag {
        guard let objectView = R.nib.twoLinesAndTag.instantiate(withOwner: self).first as? TwoLinesAndTag else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
