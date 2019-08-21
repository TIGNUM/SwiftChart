//
//  MyQOT.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class MyQOT: BaseSkeletonView {

    static func instantiateFromNib() -> MyQOT {
        guard let objectView = R.nib.myQOT.instantiate(withOwner: self).first as? MyQOT else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
