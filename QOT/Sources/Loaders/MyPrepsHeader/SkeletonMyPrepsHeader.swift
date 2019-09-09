//
//  SkeletonMyPrepsHeader.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonMyPrepsHeader: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonMyPrepsHeader {
        guard let objectView = R.nib.skeletonMyPrepsHeader.instantiate(withOwner: self).first as? SkeletonMyPrepsHeader else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
