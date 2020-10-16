//
//  TeamToBeVisionOptionsModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct TeamAdmin {

    enum ActionType: Int {
        case rate = 0
        case end
    }

    enum Types: Int {
        case rating
        case voting

        var pageTitle: String {
            switch self {
            case .rating: return AppTextService.get(.my_x_team_tbv_options_rate_title)
            case .voting: return AppTextService.get(.my_x_team_tbv_options_poll_title)
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

        var alertTitle: String {
            switch self {
            case .rating:
                return AppTextService.get(.my_x_team_tbv_options_rating_alert_title)
            case .voting:
                return AppTextService.get(.my_x_team_tbv_options_voting_alert_title)
            }
        }

        var alertMessage: String {
            switch self {
            case .voting:
                return AppTextService.get(.my_x_team_tbv_options_voting_alert_message)
            case .rating:
                return AppTextService.get(.my_x_team_tbv_options_rating_alert_message)
            }
        }

        private func title(for item: Option) -> String {
            switch item {
            case .vote:
                return AppTextService.get(.my_x_team_tbv_options_poll_vote_title)
            case .endPoll:
                return AppTextService.get(.my_x_team_tbv_options_poll_end_poll_title)
            case .rate:
                return AppTextService.get(.my_x_team_tbv_options_rate_rate_title)
            case .endRate:
                return AppTextService.get(.my_x_team_tbv_options_rate_end_rate_title)
            }
        }

        private func cta(for item: Option, isDisabled: Bool) -> String {
            switch item {
            case .vote:
                return isDisabled ? AppTextService.get(.my_x_team_tbv_options_poll_voted_cta) : AppTextService.get(.my_x_team_tbv_options_poll_vote_cta)
            case .endPoll:
                return AppTextService.get(.my_x_team_tbv_options_poll_end_poll_cta)
            case .rate:
                return isDisabled ? AppTextService.get(. my_x_team_tbv_options_rate_rated_cta): AppTextService.get(.my_x_team_tbv_options_rate_rate_cta)
            case .endRate:
                return AppTextService.get(.my_x_team_tbv_options_rate_end_rate_cta)
            }
        }

        func titleForItem(at indexPath: IndexPath) -> String {
            return title(for: pageValues.at(index: indexPath.row) ?? .rate)
        }

        func ctaForItem(at indexPath: IndexPath, isDisabled: Bool) -> String {
            return cta(for: pageValues.at(index: indexPath.row) ?? .vote, isDisabled: isDisabled)
        }
    }
}
