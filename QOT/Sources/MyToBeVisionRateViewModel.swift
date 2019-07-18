//
//  MyToBeVisionRateViewModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 02.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct MyToBeVisionRateViewModel {

    struct Question: NewQuestionnaire {
        let remoteID: Int
        let title: String
        let subtitle: String?
        let description: String?
        let rating: Int
        let range: Int
        var answerIndex: Int

        func questionIdentifier() -> Int {
            return remoteID
        }

        func question() -> String {
            return title
        }

        func items() -> Int {
            return range
        }

        func selectedAnswerIndex() -> Int {
            return answerIndex
        }
    }
}
