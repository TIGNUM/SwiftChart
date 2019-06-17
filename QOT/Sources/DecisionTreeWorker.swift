//
//  DecisionTreeWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

typealias DecisionTreeNode = (question: Question?, generatedAnswer: String?)

final class DecisionTreeWorker {

    // MARK: - Properties

    private let services: Services
    private var _prepareBenefits: String?
    private var _selectedAnswers: [DecisionTreeModel.SelectedAnswer] = []
    private var answerFilter: String?
    private var _targetContentID: Int = 0
    let type: DecisionTreeType

    // MARK: - Init

    init(services: Services, type: DecisionTreeType) {
        self.services = services
        self.type = type
    }
}

// MARK: - DecisionTreeWorkerInterface

extension DecisionTreeWorker: DecisionTreeWorkerInterface {
    func setTargetContentID(for answer: Answer) {
        let contentTarget = answer.decisions.filter { $0.targetType == TargetType.content.rawValue }.first
        if let targetContentID = contentTarget?.targetID {
            self.targetContentID = targetContentID
        }
    }

    func answersFilter(currentQuestion: Question?, decisionTree: DecisionTreeModel?) -> String? {
        if answerFilter != nil {
            let result = answerFilter
            answerFilter = nil
            return result
        }
        let keyFilter = "_relationship_"
        if currentQuestion?.key?.contains("prepare_peak_prep_") == true {
            return decisionTree?.selectedAnswers.compactMap { $0.answer }.flatMap { $0.keys }.filter { $0.contains(keyFilter) }.first
        }
        return decisionTree?.selectedAnswers.first?.answer.keys.first(where: { $0.contains(keyFilter) })
    }

    var targetContentID: Int {
        get {
            return _targetContentID
        }
        set {
            _targetContentID = newValue
        }
    }

    var prepareBenefits: String? {
        get {
            return _prepareBenefits
        }
        set {
            _prepareBenefits = newValue
        }
    }

    var userHasToBeVision: Bool {
        return services.userService.myToBeVision()?.text != nil && services.userService.myToBeVision()?.text?.trimmed.isEmpty == false
    }

    var selectedAnswers: [DecisionTreeModel.SelectedAnswer] {
        get {
            return _selectedAnswers
        }
        set {
            _selectedAnswers = newValue
        }
    }

    /// Returns the first question in order to start the decision tree
    func fetchFirstQuestion() -> Question? {
        switch type {
        case .toBeVisionGenerator: return services.questionsService.tbvGeneratorIntroQuestion()
        case .mindsetShifter: return services.questionsService.mindsetShifterIntroQuestion()
        case .mindsetShifterTBV: return services.questionsService.mindsetShifterTBV()
        case .prepare: return services.questionsService.prepareIntro()
        case .prepareIntensions(let selectedAnswers, let answerFilter, let questionID):
            self.answerFilter = answerFilter
            self.selectedAnswers = selectedAnswers
            return services.questionsService.question(id: questionID)
        case .prepareBenefits(let benefits, let questionId):
            prepareBenefits = benefits
            return services.questionsService.question(id: questionId)
        case .solve: return services.questionsService.solveIntro()
        }
    }

    /// Returns the first question based on `AnswerDecision.targetID` and an answer which is generated in our side.
    func fetchNextQuestion(from targetID: Int, selectedAnswers: [Answer]) -> DecisionTreeNode {
        let question = services.questionsService.question(id: targetID)
        var extraAnswer: String?
        switch question?.key {
        case QuestionKey.ToBeVision.create.rawValue,
             QuestionKey.MindsetShifterTBV.review.rawValue: extraAnswer = createVision(from: selectedAnswers)
        case QuestionKey.MindsetShifter.showTBV.rawValue,
             QuestionKey.Prepare.showTBV.rawValue: extraAnswer = services.userService.myToBeVision()?.text
        default: extraAnswer = createVision(from: selectedAnswers)/* TODO: generate different extra answers */
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

    /// Saves `ImageResource`
    func save(_ image: UIImage) {
        switch type {
        case .toBeVisionGenerator, .mindsetShifterTBV:
            saveToBeVision(image, completion: { (error) in
                if let error = error {
                    qot_dal.log(error.localizedDescription, level: .error)
                }
            })
        default: return
        }
    }

    func highPerformanceItems(from contentItemIDs: [Int]) -> [String] {
        var items: [String] = []
        contentItemIDs.forEach {
            let contentItem = services.contentService.contentItem(id: $0)
            if contentItem?.searchTags.contains("mindsetshifter-highperformance-item") ?? false == true {
                items.append(contentItem?.valueText ?? "")
            }
        }
        return items
    }
}

// MARK: - Private TBV

private extension DecisionTreeWorker {

    var workQuestion: Question? {
        switch type {
        case .toBeVisionGenerator: return services.questionsService.question(for: QuestionKey.ToBeVision.work.rawValue)
        case .mindsetShifterTBV: return services.questionsService.question(for: QuestionKey.MindsetShifterTBV.work.rawValue)
        default: return nil
        }
    }

    var homeQuestion: Question? {
        switch type {
        case .toBeVisionGenerator: return services.questionsService.question(for: QuestionKey.ToBeVision.home.rawValue)
        case .mindsetShifterTBV: return services.questionsService.question(for: QuestionKey.MindsetShifterTBV.home.rawValue)
        default: return nil
        }
    }

    /// Generates the vision based on the list of selected `Answer`
    func createVision(from answers: [Answer]) -> String {
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
        let targetIDs = answers.compactMap { $0.decisions.first(where: { $0.targetType == TargetType.content.rawValue })?.targetID }
        for targetID in targetIDs {
            let contentItems = services.contentService.contentItems(contentCollectionID: targetID)
            let userGender = (services.userService.user()?.gender ?? "NEUTRAL").uppercased()
            let genderQueryNeutral = "GENDER_NEUTRAL"
            let genderQuery = String(format: "GENDER_%@", userGender)
            let filteredItems = Array(contentItems.filter { $0.searchTags.contains(genderQuery)
                || $0.searchTags.contains(genderQueryNeutral) })
            guard filteredItems.isEmpty == false else { continue }
            if let randomItemText = filteredItems[filteredItems.randomIndex].valueText {
                visionList.append(randomItemText)
            }
        }
        return visionList.joined(separator: " ")
    }

    func saveToBeVision(_ image: UIImage, completion: @escaping (Error?) -> Void) {
        do {
            let imageURL = try image.save(withName: UUID().uuidString).absoluteString
            qot_dal.UserService.main.getMyToBeVision { (vision, _, _) in
                if var vision = vision {
                    vision.profileImageResource = QDMMediaResource()
                    vision.profileImageResource?.localURLString = imageURL
                    vision.modifiedAt = Date()
                    qot_dal.UserService.main.updateMyToBeVision(vision, { (error) in
                        completion(error)
                    })
                }
            }
        } catch {
            print("Error while saving TBV image: \(error.localizedDescription)")
        }
    }
}
