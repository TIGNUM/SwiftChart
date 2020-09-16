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
    }

    enum Option: CaseIterable {
        case vote
        case endPoll
        case rate
        case endRate
    }

    var votingPage: [Option] {
        return [.vote, .endPoll]
    }

    var ratingPage: [Option] {
        return [.rate, .endRate]
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

    var ratingCount: Int {
        return ratingPage.count
    }

    var votingCount: Int {
        return votingPage.count
    }

    func titleForItem(at indexPath: IndexPath, type: Types) -> String {
        switch type {
        case .rating:
             return title(for: ratingPage.at(index: indexPath.row) ?? .rate)
        case .voting:
            return title(for: votingPage.at(index: indexPath.row) ?? .vote)
        }
    }

    func ctaForItem(at indexPath: IndexPath, type: Types) -> String {
        switch type {
        case .rating:
             return cta(for: ratingPage.at(index: indexPath.row) ?? .rate)
        case .voting:
            return cta(for: votingPage.at(index: indexPath.row) ?? .vote)
        }
    }
}
