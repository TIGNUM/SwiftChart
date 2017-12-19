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

            var value: String {
                switch self {
                case .text(let value): return value
                }
            }
        }

        enum Link {
            case path(String)

            var url: URL? {
                switch self {
                case .path(let urlString): return URL(string: urlString)
                }
            }
        }

        let status: GuideViewModel.Status
        let title: String
        let content: Content
        let subtitle: String
        let type: String
        let link: Link
        let identifier: String
    }

    struct Day {
        let items: [Item]
    }
}
