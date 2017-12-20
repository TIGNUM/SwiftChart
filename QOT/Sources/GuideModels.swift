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

        struct DailyPrep {
            let feedback: String?
            let results: [String]

            var labels: [String] {
                return ["Sleep\nQuality", "Sleep\nQuantity", "Load\nIndex", "Load\nFoo", "Recovery\nIndex"]
            }

            var empty: [String] {
                return ["_", "_", "_", "_", "_"]
            }
        }

        let status: GuideViewModel.Status
        let title: String
        let content: Content
        let subtitle: String
        let type: String
        let link: Link
        let featureLink: Link?
        let identifier: String
        let dailyPrep: DailyPrep?
        let greeting: String?
        let createdAt: Date

        var isDailyPrep: Bool {
            return RealmGuideItemNotification.ItemType.morningInterview.rawValue == type
        }

        var isDailyPrepCompleted: Bool {
            return isDailyPrep == true && status == .done
        }
    }

    struct Day {
        let items: [Item]
    }
}
