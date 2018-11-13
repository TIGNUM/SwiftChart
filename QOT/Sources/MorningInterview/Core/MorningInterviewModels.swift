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
        let htmlTitle: String?
        let subtitle: String?
        let answers: [Answer]
        let key: String?
        var selectedAnswerIndex: Int

        init?(remoteID: Int, title: String, htmlTitle: String?, subtitle: String?, answers: [Answer], key: String?, selectedAnswerIndex: Int) {
            guard answers.count > 0 else { return nil }

            self.remoteID = remoteID
            self.title = title
            self.htmlTitle = htmlTitle
            self.subtitle = subtitle
            self.answers = answers
            self.key = key
            self.selectedAnswerIndex = selectedAnswerIndex
        }

        var selectedAnswer: Answer {
            return answers[selectedAnswerIndex]
        }
    }
}
