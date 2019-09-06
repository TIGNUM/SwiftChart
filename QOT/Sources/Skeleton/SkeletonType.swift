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

    var objectView: BaseSkeletonView {
        switch self {
        case .oneLineHeading:
            return OneLineHeading.instantiateFromNib()
        case .oneLineBlock:
            return OneLineBlock.instantiateFromNib()
        case .twoLinesAndTag:
            return TwoLinesAndTag.instantiateFromNib()
        case .twoLinesAndImage:
            return TwoLinesAndImage.instantiateFromNib()
        case .threeLinesAndTwoColumns:
            return ThreeLinesAndTwoColumns.instantiateFromNib()
        case .threeLinesLeftColumn:
            return ThreeLinesLeftColumn.instantiateFromNib()
        case .fiveLinesWithTopBroad:
            return FiveLinesWithTopBroad.instantiateFromNib()
        case .dailyBrief:
            return DailyBrief.instantiateFromNib()
        case .myQOT:
            return MyQOT.instantiateFromNib()
        case .padHeading:
            return PadHeading.instantiateFromNib()
        case .myQOTCell:
            return MyQOTCell.instantiateFromNib()
        case .myPrepsHeader:
            return MyPrepsHeader.instantiateFromNib()
        case .myPrepsCell:
            return MyPrepsCell.instantiateFromNib()
        case .myDataGraph:
            return MyDataGraph.instantiateFromNib()
        case .dailyCheckInHeader:
            return DailyCheckInHeader.instantiateFromNib()
        case .dailyCheckInRow:
            return DailyCheckInRow.instantiateFromNib()
        case .dailyCheckInFooter:
            return DailyCheckInFooter.instantiateFromNib()
        default:
            return Loader.instantiateFromNib()
        }
    }
}
