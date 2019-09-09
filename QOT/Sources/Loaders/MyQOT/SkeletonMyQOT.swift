//
//  SkeletonMyQOT.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonMyQOT: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonMyQOT {
        guard let objectView = R.nib.skeletonMyQOT.instantiate(withOwner: self).first as? SkeletonMyQOT else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
