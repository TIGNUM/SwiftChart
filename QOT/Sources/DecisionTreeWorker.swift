//
//  DecisionTreeWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

typealias DecisionTreeNode = (question: Question?, extraAnswer: String?)

final class DecisionTreeWorker {

    // MARK: - Properties

    private let services: Services
    private let type: DecisionTreeType

    // MARK: - Init

    init(services: Services, type: DecisionTreeType) {
        self.services = services
        self.type = type
    }

    /// Returns the first question in order to start the decision tree
    func fetchFirstQuestion() -> Question? {
        switch type {
        case .toBeVisionGenerator:
            return services.questionsService.visionQuestion(for: .intro)
        case .prepare:
            return nil
        }
    }

    /// Returns the first question based on `AnswerDecision.targetID`
    func fetchNextQuestion(from targetID: Int, selectedAnswers: [Answer]) -> DecisionTreeNode {
        let question = services.questionsService.question(id: targetID)
        var extraAnswer: String?
        switch question?.key {
        case QuestionKey.create.rawValue:
            extraAnswer = createVision(from: selectedAnswers)
        default: // TODO: generate different extra answers
            extraAnswer = createVision(from: selectedAnswers)
        }
        return (question, extraAnswer)
    }

    /// Returns the media url for a specific content item
    func mediaURL(from contentItemID: Int) -> URL? {
        guard
            let urlString = services.contentService.contentItem(id: contentItemID)?.valueMediaURL,
            let url = URL(string: urlString) else { return nil }
        return url
    }
}

// MARK: - Private

extension DecisionTreeWorker {

    /// Generates the vision based on the list of selected `Answer`
    func createVision(from answers: [Answer]) -> String {
        let workQuestion = services.questionsService.question(for: "tbv-generator-key-work")
        let homeQuestion = services.questionsService.question(for: "tbv-generator-key-home")
        var workSelections: [Answer] = []
        var homeSelections: [Answer] = []
        for answer in answers {
            workQuestion?.answers.forEach {
                if $0.remoteID.value == answer.remoteID.value {
                    workSelections.append(answer)
                }
            }
            homeQuestion?.answers.forEach {
                if $0.remoteID.value == answer.remoteID.value {
                    homeSelections.append(answer)
                }
            }
        }
        let vision = [string(from: workSelections), string(from: homeSelections)].joined(separator: "\n\n")
        services.userService.updateVision(vision)
        return vision
    }

    func string(from answers: [Answer]) -> String {
        var visionList: [String] = []
        for targetID in answers.compactMap({ $0.decisions.first?.targetID }) {
            let contentItems = services.contentService.contentItems(contentCollectionID: targetID)
            let userGender = (services.userService.user()?.gender ?? "NEUTRAL").uppercased()
            let genderQueryNeutral = "GENDER_NEUTRAL"
            let genderQuery = String(format: "GENDER_%@", userGender)
            let filteredItems = Array(contentItems.filter { $0.searchTags.contains(genderQuery) || $0.searchTags.contains(genderQueryNeutral) })
            guard filteredItems.isEmpty == false else { continue }
            if let randomItemText = filteredItems[filteredItems.randomIndex].valueText {
                visionList.append(randomItemText)
            }
        }
        return visionList.joined(separator: " ")
    }
}
