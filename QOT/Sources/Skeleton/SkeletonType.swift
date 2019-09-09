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
    case twoLinesAndImage
    case threeLinesAndTwoColumns
    case threeLinesLeftColumn
    case fiveLinesWithTopBroad
    case loader
    case dailyBrief
    case myQOT
    case padHeading
    case myQOTCell
    case myPrepsHeader
    case myPrepsCell
    case myDataGraph
    case dailyCheckInHeader
    case dailyCheckInRow
    case dailyCheckInFooter

    static var defaultSkeleton: SkeletonType {
        return SkeletonType.loader
    }

    var objectView: SkeletonBaseView {
        switch self {
        case .oneLineHeading:
            return SkeletonOneLineHeading.instantiateFromNib()
        case .oneLineBlock:
            return SkeletonOneLineBlock.instantiateFromNib()
        case .twoLinesAndTag:
            return SkeletonTwoLinesAndTag.instantiateFromNib()
        case .twoLinesAndImage:
            return SkeletonTwoLinesAndImage.instantiateFromNib()
        case .threeLinesAndTwoColumns:
            return SkeletonThreeLinesAndTwoColumns.instantiateFromNib()
        case .threeLinesLeftColumn:
            return SkeletonThreeLinesLeftColumn.instantiateFromNib()
        case .fiveLinesWithTopBroad:
            return SkeletonFiveLinesWithTopBroad.instantiateFromNib()
        case .dailyBrief:
            return SkeletonDailyBrief.instantiateFromNib()
        case .myQOT:
            return SkeletonMyQOT.instantiateFromNib()
        case .padHeading:
            return SkeletonPadHeading.instantiateFromNib()
        case .myQOTCell:
            return SkeletonMyQOTCell.instantiateFromNib()
        case .myPrepsHeader:
            return SkeletonMyPrepsHeader.instantiateFromNib()
        case .myPrepsCell:
            return SkeletonMyPrepsCell.instantiateFromNib()
        case .myDataGraph:
            return SkeletonMyDataGraph.instantiateFromNib()
        case .dailyCheckInHeader:
            return SkeletonDailyCheckInHeader.instantiateFromNib()
        case .dailyCheckInRow:
            return SkeletonDailyCheckInRow.instantiateFromNib()
        case .dailyCheckInFooter:
            return SkeletonDailyCheckInFooter.instantiateFromNib()
        default:
            return SkeletonLoader.instantiateFromNib()
        }
    }
}
