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

        var contentId: Int {
            switch self {
            case .sprint:
                return 103051
            case .mindsetShifter:
                return 103052
            }
        }
    }


    struct ViewModel {
        let title: String?
        let description: String?
    }
}
