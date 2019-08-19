//
//  TwoLinesAndImage.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class TwoLinesAndImage: BaseSkeletonView {

    static func instantiateFromNib() -> TwoLinesAndImage {
        guard let objectView = R.nib.twoLinesAndImage.instantiate(withOwner: self).first as? TwoLinesAndImage else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
