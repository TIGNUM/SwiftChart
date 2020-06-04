//
//  FeatureExplainerModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 26.05.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

struct FeatureExplainer {

    enum Kind: String {
        case sprint
        case mindsetShifter
        case tools
        case solve
        case recovery
        case prepare

        var contentId: Int {
            switch self {
            case .sprint:
                return 103197
            case .mindsetShifter:
                return 103201
            case .tools:
                return 103198
            case .solve:
                return 103200
            case .recovery:
                return 103202
            case .prepare:
                return 103199
            }
        }
    }

    struct ViewModel {
        let title: String?
        let description: String?
    }
}
