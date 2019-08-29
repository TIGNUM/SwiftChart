//
//  DailyBrief.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import UIKit

final class MyDataGraph: BaseSkeletonView {

    static func instantiateFromNib() -> MyDataGraph {
        guard let objectView = R.nib.myDataGraph.instantiate(withOwner: self).first as? MyDataGraph else {
            fatalError("Cannot load view")
        }
        return objectView
    }
}
