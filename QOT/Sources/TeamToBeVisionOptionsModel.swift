//
//  TeamToBeVisionOptionsModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

struct TeamToBeVisionOptionsModel {

    enum Types: Int {
        case rating
        case voting

        var pageTitle: String {
            switch self {
            case .rating: return "TEAM RATING IN PROGRESS"
            case .voting: return "TEAM TOBEVISION POLL"
            }
        }

        var count: Int {
            return pageValues.count
        }

        enum Option: CaseIterable {
            case vote
            case endPoll
            case rate
            case endRate
        }

        var pageValues: [Option] {
            switch self {
            case .rating:
                return [.rate, .endRate]
            case .voting:
                return [.vote, .endPoll]
            }
        }

        private func title(for item: Option) -> String {
            switch item {
            case .vote:
                return "Vote team qualities"
            case .endPoll:
                return "End Poll"
            case .rate:
                return "Rate Team ToBeVision"
            case .endRate:
                return "End rating for all"
            }
        }

        private func cta(for item: Option) -> String {
            switch item {
            case .vote:
                return "Vote"
            case .endPoll:
                return "Proceed"
            case .rate:
                return "Rate"
            case .endRate:
                return "Proceed"
            }
        }

        func titleForItem(at indexPath: IndexPath) -> String {
            return title(for: pageValues.at(index: indexPath.row) ?? .rate)
        }

        func ctaForItem(at indexPath: IndexPath) -> String {
            return cta(for: pageValues.at(index: indexPath.row) ?? .vote)
        }
    }
}
