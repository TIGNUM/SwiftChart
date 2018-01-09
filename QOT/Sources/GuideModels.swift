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

            var groupID: String? {
                switch self {
                case .path(let urlString): return URL(string: urlString)?.queryStringParameter(param: "groupID")
                }
            }
        }

        struct DailyPrep {
            let questionGroupID: String?
            let services: Services
            let feedback: String?
            let results: [String]

            var labels: [String] {
                guard
                    let groupStringID = questionGroupID,
                    let questionGroupID = Int(groupStringID) else { return [] }
                return services.questionsService.morningInterviewTitles(questionGroupID: questionGroupID)
            }

            var empty: [String] {
                return ["_", "_", "_", "_", "_"]
            }

            var questionCount: Int {
                guard let groupStringID = questionGroupID, let groupID = Int(groupStringID) else { return 0 }
                let questions = services.questionsService.morningInterviewQuestions(questionGroupID: groupID)
                return Array(questions).count
            }
        }

        let status: GuideViewModel.Status
        let title: String
        let content: Content
        let subtitle: String
        let type: String
        let link: Link
        let featureLink: Link?
        let featureButton: String?
        let identifier: String
        let notificationID: String
        let dailyPrep: DailyPrep?
        let greeting: String
        let createdAt: Date

        var isDailyPrep: Bool {
            return RealmGuideItemNotification.ItemType.morningInterview.rawValue == type ||
                    RealmGuideItemNotification.ItemType.weeklyInterview.rawValue == type
        }

        var isDailyPrepCompleted: Bool {
            return isDailyPrep == true && status == .done
        }
    }

    struct Day {
        let items: [Item]
        let createdAt: Date
    }
}
