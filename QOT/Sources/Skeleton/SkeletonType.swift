//
//  SkeletonType.swift
//  LoadingSkeleton
//
//  Created by Ashish Maheshwari on 05.06.19.
//  Copyright © 2019 Ashish Maheshwari. All rights reserved.
//

import Foundation

enum SkeletonType {
    case oneLineHeading
    case oneLineBlock
    case twoLinesAndTag
    case twoLinesAndButton
    case twoLinesAndImage
    case threeLinesAndImage
    case threeLinesTwoColumns
    case threeLinesLeftColumn
    case threeLinesAndButton
    case fiveLines
    case fiveLinesWithTopBroad
    case loader

    static var defaultSkeleton: SkeletonType {
        return SkeletonType.loader
    }

    var objectView: BaseSkeletonView {
        switch self {
        case .oneLineHeading:
            return OneLineHeading.instantiateFromNib()
        case .oneLineBlock:
            return OneLineBlock.instantiateFromNib()
        case .twoLinesAndTag:
            return TwoLinesAndTag.instantiateFromNib()
        case .twoLinesAndButton:
            return TwoLinesAndButton.instantiateFromNib()
        case .twoLinesAndImage:
            return TwoLinesAndImage.instantiateFromNib()
        case .threeLinesAndImage:
            return ThreeLinesAndImage.instantiateFromNib()
        case .threeLinesTwoColumns:
            return ThreeLinesTwoColumns.instantiateFromNib()
        case .threeLinesLeftColumn:
            return ThreeLinesLeftColumn.instantiateFromNib()
        case .threeLinesAndButton:
            return ThreeLinesAndButton.instantiateFromNib()
        case .fiveLines:
            return FiveLines.instantiateFromNib()
        case .fiveLinesWithTopBroad:
            return FiveLinesWithTopBroad.instantiateFromNib()
        default:
            return Loader.instantiateFromNib()
        }
    }
}
