//
//  SkeletonMyPrepsCell.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonMyPrepsCell: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonMyPrepsCell {
        guard let objectView = R.nib.skeletonMyPrepsCell.instantiate(withOwner: self).first as? SkeletonMyPrepsCell else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
