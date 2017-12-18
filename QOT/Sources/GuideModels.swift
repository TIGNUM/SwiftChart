//
//  GuideModels.swift
//  QOT
//
//  Created by Sam Wyndham on 15.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

struct Guide {

    struct Item {

        enum Content {
            case text(String)
        }

        let status: GuideViewModel.Status
        let title: String
        let content: Content
        let subtitle: String
    }

    struct Day {

        let items: [Item]
    }
}
