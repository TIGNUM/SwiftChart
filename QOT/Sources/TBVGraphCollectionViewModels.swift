//
//  TBVGraphCollectionViewModels.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct TBVGraph {

    struct Range {
        let inital: Int
        let final: Int

        func barHeight(for rating: CGFloat) -> CGFloat {
            let barHeight: CGFloat = 202
            return (barHeight / CGFloat(final)) * rating
        }

        static func defaultRange() -> Range {
            return Range(inital: 1, final: 10)
        }
    }

    struct BarGraphConfig {
        let graphBarColor: UIColor
        let progressBarColor: UIColor
        let selectedBarColor: UIColor
        let unSelectedFont: UIFont
        let selectedFont: UIFont
        let ratingCircleColor: UIColor
        let selectedBarRatingColor: UIColor
        let unSelectedBarRatingColor: UIColor

        static func tbvDataConfig() -> BarGraphConfig {
            return BarGraphConfig(graphBarColor: .darkGrey,
                                  progressBarColor: .lightGrey,
                                  selectedBarColor: .white,
                                  unSelectedFont: .sfProtextLight(ofSize: 16),
                                  selectedFont: .sfProtextSemibold(ofSize: 16),
                                  ratingCircleColor: .white,
                                  selectedBarRatingColor: .black,
                                  unSelectedBarRatingColor: .lightGrey)

        }

        static func tbvTrackerConfig() -> BarGraphConfig {
            return BarGraphConfig(graphBarColor: .darkGrey,
                                  progressBarColor: .lightGrey,
                                  selectedBarColor: .white,
                                  unSelectedFont: .sfProtextLight(ofSize: 16),
                                  selectedFont: .sfProtextSemibold(ofSize: 16),
                                  ratingCircleColor: .clear,
                                  selectedBarRatingColor: .white,
                                  unSelectedBarRatingColor: .lightGrey)

        }
    }

    enum BarTypes: Int {
        case range = 0
        case first = 1
        case firstCompanion = 2
        case second = 4
        case secondCompanion = 5
        case third = 7
        case thirdCompanion = 8
        case future = 10

        static var numberOfGraphs: Int {
            return 11
        }

        var index: Int {
            switch self {
            case .first,
                 .firstCompanion: return .zero
            case .second,
                 .secondCompanion: return 1
            case .third,
                 .thirdCompanion,
                 .future: return 2
            default: return .max
            }
        }
    }

    enum Section: Int, CaseIterable {
        case header = 0
        case graph
        case sentence

        var height: CGFloat {
            switch self {
            case .header: return CGFloat(150)
            case .graph: return CGFloat(0.1)
            case .sentence: return CGFloat(68)
            }
        }
    }

    enum DisplayType {
        case tracker
        case data

        var config: TBVGraph.BarGraphConfig {
            switch self {
            case .tracker: return .tbvTrackerConfig()
            case .data: return .tbvDataConfig()
            }
        }
    }
}
