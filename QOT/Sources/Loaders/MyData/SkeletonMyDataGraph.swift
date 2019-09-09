//
//  SkeletonMyDataGraph.swift
//  LoadingSkeleton
//
//  Created by Voicu on 26.08.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class SkeletonMyDataGraph: SkeletonBaseView {

    static func instantiateFromNib() -> SkeletonMyDataGraph {
        guard let objectView = R.nib.skeletonMyDataGraph.instantiate(withOwner: self).first as? SkeletonMyDataGraph else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
