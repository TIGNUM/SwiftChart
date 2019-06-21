//
//  SkeletonType.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import Foundation

enum SkeletonType {
    case twoLinesAndButton
    case threeLinesAndButton
    case twoLinesAndImage
    case threeLinesAndImage
    case threeLines
    case fiveLines
    case fiveLinesWithTopBroad
    case loader

    static var defaultSkeleton: SkeletonType {
        return SkeletonType.loader
    }
}
