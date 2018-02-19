//
//  MorningInterviewModels.swift
//  QOT
//
//  Created by Sam Wyndham on 19/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

struct MorningInterview {

    struct Answer {

        let remoteID: Int
        let title: String
        let subtitle: String?
    }

    class Question {

        let remoteID: Int
        let title: String
        let subtitle: String?
        let answers: [Answer]
        var selectedAnswerIndex: Int

        init?(remoteID: Int, title: String, subtitle: String?, answers: [Answer], selectedAnswerIndex: Int) {
            guard answers.count > 0 else { return nil }

            self.remoteID = remoteID
            self.title = title
            self.subtitle = subtitle
            self.answers = answers
            self.selectedAnswerIndex = selectedAnswerIndex
        }

        var selectedAnswer: Answer {
            return answers[selectedAnswerIndex]
        }
    }
}
