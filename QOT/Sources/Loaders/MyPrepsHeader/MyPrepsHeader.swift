//
//  MyPrepsHeader.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class MyPrepsHeader: BaseSkeletonView {

    static func instantiateFromNib() -> MyPrepsHeader {
        guard let objectView = R.nib.myPrepsHeader.instantiate(withOwner: self).first as? MyPrepsHeader else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
