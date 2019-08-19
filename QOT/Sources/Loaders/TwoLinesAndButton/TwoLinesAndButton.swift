//
//  TwoLinesAndButton.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class TwoLinesAndButton: BaseSkeletonView {

    static func instantiateFromNib() -> TwoLinesAndButton {
        guard let objectView = R.nib.twoLinesAndButton.instantiate(withOwner: self).first as? TwoLinesAndButton else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
