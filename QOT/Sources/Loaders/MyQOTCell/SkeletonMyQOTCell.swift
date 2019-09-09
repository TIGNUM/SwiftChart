//
//  SkeletonMyQOTCell.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonMyQOTCell: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonMyQOTCell {
        guard let objectView = R.nib.skeletonMyQOTCell.instantiate(withOwner: self).first as? SkeletonMyQOTCell else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
