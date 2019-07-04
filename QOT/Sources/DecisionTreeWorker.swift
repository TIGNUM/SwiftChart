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
    private let userService = qot_dal.UserService.main
    private let contentService = qot_dal.ContentService.main
    private let questionService = qot_dal.QuestionService.main
    private var _prepareBenefits: String?
    private var prepareKey: Prepare.Key = .perceived
    private var _selectedAnswers: [DecisionTreeModel.SelectedAnswer] = []
    private var answerFilter: String?
    private var _targetContentID: Int = 0
    private var visionText: String? = nil
    private var recoveryModel: QDMRecovery3D?
    let type: DecisionTreeType
    weak var prepareDelegate: PrepareResultsDelegatge?

    // MARK: - Init

    init(services: Services, type: DecisionTreeType) {
        self.services = services
        self.type = type
    }
}

// MARK: - DecisionTreeWorkerInterface

extension DecisionTreeWorker: DecisionTreeWorkerInterface {
    var userHasToBeVision: Bool {
        return visionText != nil && visionText?.trimmed.isEmpty == false
    }

    var getToBeVisionText: String? {
        return visionText
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

    var getRecoveryModel: QDMRecovery3D? {
        return recoveryModel
    }

    var selectedAnswers: [DecisionTreeModel.SelectedAnswer] {
        get {
            return _selectedAnswers
        }
        set {
            _selectedAnswers = newValue
        }
    }

    func fetchToBeVision() {
        qot_dal.UserService.main.getMyToBeVision { [weak self] (vision, status, _) in
            self?.visionText = vision?.text
        }
    }

    func didUpdatePrepareIntentions(_ answers: [DecisionTreeModel.SelectedAnswer]) {
        prepareDelegate?.didUpdateIntentions(answers, prepareKey)
    }

    func didUpdateBenefits(_ benefits: String) {
        prepareDelegate?.didUpdateBenefits(benefits)
    }

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
        let keyFilter: DecisionTreeModel.Filter = .FILTER_RELATIONSHIP
        if currentQuestion?.key?.contains("prepare_peak_prep_") == true {
            return decisionTree?.selectedAnswers
                .compactMap { $0.answer }
                .flatMap { $0.keys }
                .filter { $0.contains(keyFilter) }.first
        }
        return decisionTree?.selectedAnswers.first?.answer.keys.first(where: { $0.contains(keyFilter) })
    }

    /// Returns the first question in order to start the decision tree
    func fetchFirstQuestion() -> Question? {
        switch type {
        case .toBeVisionGenerator: return services.questionsService.tbvGeneratorIntroQuestion()
        case .mindsetShifter: return services.questionsService.mindsetShifterIntroQuestion()
        case .mindsetShifterTBV: return services.questionsService.mindsetShifterTBV()
        case .prepare: return services.questionsService.prepareIntro()
        case .prepareIntensions(let selectedAnswers, let answerFilter, let key, let delegate):
            self.answerFilter = answerFilter
            self.selectedAnswers = selectedAnswers
            self.prepareKey = key
            self.prepareDelegate = delegate
            return services.questionsService.question(id: key.questionID)
        case .prepareBenefits(let benefits, let questionId, let delegate):
            prepareBenefits = benefits
            prepareDelegate = delegate
            return services.questionsService.question(id: questionId)
        case .solve: return services.questionsService.solveIntro()
        case .recovery:
            createRecoveryModel()
            return services.questionsService.recoveryIntro()
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
             QuestionKey.Prepare.showTBV.rawValue:
            userService.getMyToBeVision { (vision, _, _) in
                extraAnswer = vision?.text
            }
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

    func highPerformanceItems(from contentItemIDs: [Int], completion: @escaping ([String]) -> Void) {
        var items: [String] = []
        let dispatchGroup = DispatchGroup()
        contentItemIDs.forEach {
            dispatchGroup.enter()
            contentService.getContentItemById($0, { (item) in
                if item?.searchTags.contains("mindsetshifter-highperformance-item") ?? false == true {
                    items.append(item?.valueText ?? "")
                    dispatchGroup.leave()
                }
            })
        }
        dispatchGroup.notify(queue: .main) {
            completion(items)
        }
    }

    func updateRecoveryModel(fatigueAnswerId: Int, _ causeAnwserId: Int, _ targetContentId: Int) {
        qot_dal.ContentService.main.getContentCollectionById(targetContentId) { [weak self] (content) in
            self?.recoveryModel?.fatigueAnswerId = fatigueAnswerId
            self?.recoveryModel?.causeAnwserId = causeAnwserId
            self?.recoveryModel?.exclusiveContentCollectionIds = content?.relatedContentIdsRecoveryExclusive ?? []
            self?.recoveryModel?.suggestedSolutionsContentCollectionIds = content?.suggestedContentIdsRecovery ?? []
            self?.updateRecoveryModel(recovery: self?.recoveryModel)
        }
    }

    func deleteModelIfNeeded() {
        switch type {
        case .recovery: deleteRecoveryModel(recoveryModel)
        default: break
        }
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
            userService.getMyToBeVision { [unowned self] (vision, _, _) in
                if var vision = vision {
                    vision.profileImageResource = QDMMediaResource()
                    vision.profileImageResource?.localURLString = imageURL
                    vision.modifiedAt = Date()
                    self.userService.updateMyToBeVision(vision, { (error) in
                        completion(error)
                    })
                }
            }
        } catch {
            print("Error while saving TBV image: \(error.localizedDescription)")
        }
    }
}

// MARK: - Recovery3D

private extension DecisionTreeWorker {
    func createRecoveryModel() {
        qot_dal.UserService.main.createRecovery3D(fatigueAnswerId: 0,
                                                  causeAnwserId: 0,
                                                  causeContentItemId: 0,
                                                  exclusiveContentCollectionIds: [],
                                                  suggestedSolutionsContentCollectionIds: []) { [weak self] (recoveryModel, error) in
                                                    if let error = error {
                                                        qot_dal.log("Error while trying to CREATE QDMRecovery3D with error: \(error.localizedDescription)",
                                                            level: .debug)
                                                    }
                                                    self?.recoveryModel = recoveryModel
        }
    }

    func updateRecoveryModel(recovery: QDMRecovery3D?) {
        guard let recovery = recovery else { return }
        qot_dal.UserService.main.updateRecovery3D(recovery) { [weak self] (recovery, error) in
            if let error = error {
                qot_dal.log("Error while trying to UPDATE QDMRecovery3D with error: \(error.localizedDescription)",
                    level: .debug)
            }
            self?.recoveryModel = recovery
        }
    }

    func deleteRecoveryModel(_ recoveryModel: QDMRecovery3D?) {
        guard let recoveryModel = recoveryModel else { return }
        qot_dal.UserService.main.deleteRecovery3D(recoveryModel) { (error) in
            if let error = error {
                qot_dal.log("Error while trying to DELETE QDMRecovery3D with error: \(error.localizedDescription)",
                    level: .debug)
            }
        }
    }
}
