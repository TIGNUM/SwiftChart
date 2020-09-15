//
//  TeamToBeVisionOptionsModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

struct TeamToBeVisionOptionsModel {

    enum Option: CaseIterable {
        case vote
        case endPoll
    }

    private func title(for item: Option) -> String {
        switch item {
        case .vote:
            return "Vote team qualities"
        case .endPoll:
            return "End Poll"
        }
    }

    private func cta(for item: Option) -> String {
        switch item {
        case .vote:
            return "Vote"
        case .endPoll:
            return "Proceed"
        }
    }

    var sectionCount: Int {
        return Option.allCases.count
    }

    func titleForItem(at indexPath: IndexPath) -> String {
        return title(for: Option.allCases.at(index: indexPath.row) ?? .vote)
    }

    func ctaForItem(at indexPath: IndexPath) -> String {
        return cta(for: Option.allCases.at(index: indexPath.row) ?? .vote)
    }
}
