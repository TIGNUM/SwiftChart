//
//  MyProfileHeading.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class MyQOTCell: BaseSkeletonView {

    static func instantiateFromNib() -> MyQOTCell {
        guard let objectView = R.nib.myQOTCell.instantiate(withOwner: self).first as? MyQOTCell else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
