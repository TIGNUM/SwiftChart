//
//  MyPrepsCell.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class MyPrepsCell: BaseSkeletonView {

    static func instantiateFromNib() -> MyPrepsCell {
        guard let objectView = R.nib.myPrepsCell.instantiate(withOwner: self).first as? MyPrepsCell else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
