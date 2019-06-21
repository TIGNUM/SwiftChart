//
//  AnimationType.swift
//  QOT
//
//  Created by Ashish Maheshwari on 06.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

enum SkeletonAnimationType {
    case fade

    static var defaultSkeletonAnimation: SkeletonAnimationType {
        return SkeletonAnimationType.fade
    }
}
