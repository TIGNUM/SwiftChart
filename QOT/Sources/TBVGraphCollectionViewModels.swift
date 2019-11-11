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
        static func defaultRange() -> Range {
            return Range(inital: 1, final: 10)
        }
    }

    struct Rating {
        var isSelected: Bool
        let rating: CGFloat
        let isoDate: Date

        static func defaultRating() -> Rating {
            return Rating(isSelected: false, rating: 0.0, isoDate: Date(timeIntervalSince1970: 0))
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
            return BarGraphConfig(graphBarColor: .sand08,
                                  progressBarColor: .accent40,
                                  selectedBarColor: .accent,
                                  unSelectedFont: .sfProtextLight(ofSize: 16),
                                  selectedFont: .sfProtextSemibold(ofSize: 16),
                                  ratingCircleColor: .accent40,
                                  selectedBarRatingColor: .accent,
                                  unSelectedBarRatingColor: .accent70)

        }

        static func tbvTrackerConfig() -> BarGraphConfig {
            return BarGraphConfig(graphBarColor: .sand08,
                                  progressBarColor: .sand40,
                                  selectedBarColor: .sand,
                                  unSelectedFont: .sfProtextLight(ofSize: 16),
                                  selectedFont: .sfProtextSemibold(ofSize: 16),
                                  ratingCircleColor: .clear,
                                  selectedBarRatingColor: .sand,
                                  unSelectedBarRatingColor: .sand70)

        }
    }
}
