//
//  File.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/28/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class MorningInterviewViewModel {

    struct Question {
        let title: String
        let answers: [Answer]
    }

    struct Answer {
        let title: String
        let subtitle: String
    }

    let questions: [Question] = [

        .init(title: "How would you rate the amount of your sleep today? ", answers: addNumbers()),
        .init(title: "How would you rate the amount of water you drink today? ", answers: addNumbers()),
        .init(title: "How would you rate the Tignum services? ", answers: addNumbers()),
        .init(title: "How would you rate my assiatance? ", answers: addNumbers()),
        .init(title: "How would you rate the amount of time of your worked today? ", answers: addNumbers()),
        .init(title: "How would you rate the amount of your time spend with family ? ", answers: addNumbers()),
        .init(title: "How would you rate the amount of Shut up? ", answers: addNumbers())
    ]

    let answers: [Int] = []
}

func addNumbers() -> [MorningInterviewViewModel.Answer] {
    let names = ["awesome", "best", "better", "good", "average", "awesome", "bad", "very bad"]

    var answers: [MorningInterviewViewModel.Answer] = []
    for index in 0..<names.count {
        answers.append(MorningInterviewViewModel.Answer.init(title: String(index), subtitle: names[index]))
    }
    return answers
}
