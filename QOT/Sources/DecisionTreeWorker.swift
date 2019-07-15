//
//  DecisionTreeWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

typealias DecisionTreeNode = (question: QDMQuestion?, generatedAnswer: String?)

final class DecisionTreeWorker {

    // MARK: - Properties
    private let userService = qot_dal.UserService.main
    private let contentService = qot_dal.ContentService.main
    private let questionService = qot_dal.QuestionService.main
    private var _prepareBenefits: String?
    private var prepareKey: Prepare.Key = .perceived
    private var _selectedAnswers: [DecisionTreeModel.SelectedAnswer] = []
    private var answerFilter: String?
    private var answerFilterMindset: String?
    private var _targetContentID: Int = 0
    private var _extraAnswer: String? = nil
    private var recoveryModel: QDMRecovery3D?
    internal var visionText: String? = nil
    internal let type: DecisionTreeType
    internal var selectedEvent = QDMUserCalendarEvent()
    internal var prepareEventType: String = ""
    internal var questions: [QDMQuestion] = []
    internal var recoveryFatigueType: AnswerKey.Recovery? = nil
    weak var prepareDelegate: PrepareResultsDelegatge?
    weak var delegate: DecisionTreeViewControllerDelegate?
    var interactor: DecisionTreeInteractorInterface?

    internal var currentQuestion: QDMQuestion? {
        return decisionTree?.questions.at(index: pageIndex)
    }

    internal var pageIndex: Int = 0 {
        didSet { syncButtons() }
    }

    var decisionTree: DecisionTreeModel? {
        didSet { syncButtons() }
    }

    internal var multiSelectionCounter: Int = 0 {
        didSet { syncButtons() }
    }

    internal var maxPossibleSelections: Int {
        return currentQuestion?.maxPossibleSelections ?? 0
    }

    internal var decisionTreeAnswers: [QDMAnswer] {
        return decisionTree?.selectedAnswers.map { $0.answer } ?? []
    }

    private var defaultButtonText: String {
        return currentQuestion?.defaultButtonText ?? ""
    }

    private var confirmationButtonText: String {
        return currentQuestion?.confirmationButtonText ?? ""
    }

    private var questionIsAnswered: Bool {
        guard decisionTree?.selectedAnswers.count ?? 0 > pageIndex else { return false }
        return decisionTree?.selectedAnswers
            .filter { $0.questionID == currentQuestion?.remoteID }
            .isEmpty == false
    }

    // MARK: - Init
    init(type: DecisionTreeType) {
        self.type = type
    }
}

// MARK: - Public Vars
extension DecisionTreeWorker {
    var extraAnswer: String? {
        return _extraAnswer
    }
    var firstQuestion: QDMQuestion? {
        return decisionTree?.questions.filter { $0.key == type.introKey }.first
    }

    var userHasToBeVision: Bool {
        return visionText != nil && visionText?.trimmed.isEmpty == false
    }

    var targetContentID: Int {
        get { return _targetContentID }
        set { _targetContentID = newValue }
    }

    var prepareBenefits: String? {
        get { return _prepareBenefits }
        set { _prepareBenefits = newValue }
    }

    var getRecoveryModel: QDMRecovery3D? {
        return recoveryModel
    }

    var selectedAnswers: [DecisionTreeModel.SelectedAnswer] {
        get { return _selectedAnswers }
        set { _selectedAnswers = newValue }
    }
}

// MARK: - Public Functions
extension DecisionTreeWorker {
    func previousQuestion() -> QDMQuestion? {
        guard pageIndex > 0 else { return nil }
        pageIndex.minus(1)
        return decisionTree?.questions[pageIndex.advanced(by: -1)]
    }

    func didUpdatePrepareIntentions(_ answers: [DecisionTreeModel.SelectedAnswer]) {
        prepareDelegate?.didUpdateIntentions(answers, prepareKey)
    }

    func didUpdateBenefits(_ benefits: String) {
        prepareDelegate?.didUpdateBenefits(benefits)
    }

    func setTargetContentID(for answer: QDMAnswer) {
        let contentTarget = answer.decisions.filter { $0.targetType == TargetType.content.rawValue }.first
        if let targetContentID = contentTarget?.targetTypeId {
            self.targetContentID = targetContentID
        }
    }

    func answersFilter() -> String? {
        if let filter = answerFilterMindset {
            switch type {
            case .mindsetShifter:
                return filter
            default:
                break
            }
        }
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
                .filter { $0.contains(keyFilter) }
                .first
        }
        if currentQuestion?.key == QuestionKey.MindsetShifter.moreInfo.rawValue {
            let selectedAnswerTitle = decisionTree?.selectedAnswers.last?.answer.title?
                .replacingOccurrences(of: " ", with: "_") ?? ""
            let relationshipKeys = decisionTree?.selectedAnswers
                .compactMap { $0.answer }
                .flatMap { $0.keys }
                .filter { $0.contains(keyFilter) }
            answerFilterMindset = relationshipKeys?.filter { $0.contains(selectedAnswerTitle) }.first
            return answerFilterMindset
        }
        return decisionTree?.selectedAnswers.first?.answer.keys.first(where: { $0.contains(keyFilter) })
    }

    func fetchQuestions(completion: @escaping () -> Void) {
        qot_dal.QuestionService
            .main
            .questionsWithQuestionGroup(type.questionGroup, ascending: true) { [weak self] (questions) in
                let firstQuestion = questions?.filter { $0.key == self?.type.introKey ?? "" }.first
                self?.questions = questions ?? []
                if let question = firstQuestion {
                    self?.decisionTree = DecisionTreeModel(question: question)
                }
                completion()
        }
    }

    /// Returns the first question based on `AnswerDecision.targetID` and an answer which is generated in our side.
    func getNextQuestion(answer: QDMAnswer?, completion: @escaping (DecisionTreeNode) -> Void) {
        let targetId = answer?.decisions.last(where: { $0.targetType == TargetType.question.rawValue})?.targetTypeId
        updateDecisionTree(from: answer, questionId: targetId ?? 0)
        getNextQuestion(targetId: targetId ?? 0, completion: completion)
    }

    func getNextQuestion(targetId: Int, completion: @escaping (DecisionTreeNode) -> Void) {
        let question = questions.filter { $0.remoteID == targetId }.first
        updateDecisionTree(from: nil, questionId: targetId)
        switch question?.key {
        case QuestionKey.ToBeVision.create.rawValue, QuestionKey.MindsetShifterTBV.review.rawValue:
            createVision(from: decisionTreeAnswers) { (vision) in
                completion((question, vision))
            }
        case QuestionKey.MindsetShifter.showTBV.rawValue, QuestionKey.Prepare.showTBV.rawValue:
            userService.getMyToBeVision { (vision, _, _) in
                completion((question, vision?.text))
            }
        default:
            completion((question, nil))
        }
    }

    /// Returns the media url for a specific content item
    func mediaURL(from contentItemID: Int, completion: @escaping (URL?) -> Void) {
        qot_dal.ContentService.main.getContentItemById(contentItemID) { (item) in
            guard let urlString = item?.valueMediaURL else {
                completion(nil)
                return
            }
            completion(URL(string: urlString))
        }
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

    func setUserCalendarEvent(event: QDMUserCalendarEvent) {
        self.selectedEvent = event
    }

    func bottomNavigationRightBarItems(action: Selector) -> [UIBarButtonItem]? {
        switch currentQuestion?.key {
        case QuestionKey.MindsetShifter.lowSelfTalk.rawValue,
             QuestionKey.MindsetShifter.openTBV.rawValue,
             QuestionKey.MindsetShifter.check.rawValue:
            let title = defaultButtonText.isEmpty ? confirmationButtonText : defaultButtonText
            return [roundedDarkButtonItem(title: title,
                                          buttonWidth: .decisionTreeButtonWidth,
                                          action: action)]
        default: return []
        }
    }

    func updateMultiSelectionCounter() {
        if currentQuestion?.answerType == AnswerType.multiSelection.rawValue {
            multiSelectionCounter = decisionTree?.selectedAnswers
                .filter { $0.questionID == currentQuestion?.remoteID }
                .count ?? 0
        }
    }

    func updateDecisionTree(from answer: QDMAnswer?, questionId: Int) {
        let question = questions.filter { $0.remoteID == questionId }.first
        if let question = question {
            if decisionTree?.questions.filter ({ $0.remoteID == question.remoteID }).isEmpty == true {
                decisionTree?.add(question)
                pageIndex.plus(1)
            }
        } else if let answer = answer {
            let selectedAnswer = DecisionTreeModel.SelectedAnswer(questionID: questionId, answer: answer)
            decisionTree?.add(selectedAnswer)
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

internal extension DecisionTreeWorker {
    func syncButtons() {
        let previousButtonIsHidden = pageIndex == 0
        var continueButtonIsHidden = true
        var backgroundColor: UIColor = .carbonDark
        switch currentQuestion?.answerType {
        case AnswerType.singleSelection.rawValue,
             AnswerType.yesOrNo.rawValue,
             AnswerType.uploadImage.rawValue:
            continueButtonIsHidden = questionIsAnswered == false
            backgroundColor = .carbonDark
        case AnswerType.multiSelection.rawValue:
            let selectionIsCompleted = multiSelectionCounter == maxPossibleSelections
            backgroundColor = selectionIsCompleted ? .carbonDark : .carbon05
            continueButtonIsHidden = false
        default: return
        }
        interactor?.syncButtons(previousButtonIsHidden: previousButtonIsHidden,
                                continueButtonIsHidden: continueButtonIsHidden,
                                backgroundColor: backgroundColor)
        updateBottomButtonTitle()
    }

    func updateBottomButtonTitle() {
        interactor?.updateBottomButtonTitle(counter: multiSelectionCounter,
                                            maxSelections: maxPossibleSelections,
                                            defaultTitle: defaultButtonText,
                                            confirmTitle: confirmationButtonText)
    }

    func roundedDarkButtonItem(title: String, image: UIImage? = nil, buttonWidth: CGFloat, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: buttonWidth,
                                                                        height: .buttonHeight))
        button.backgroundColor = .carbonDark
        let attributedTitle = NSAttributedString(string: title,
                                                 letterSpacing: 0.2,
                                                 font: .sfProtextSemibold(ofSize: 14),
                                                 textColor: .accent,
                                                 alignment: .center)
        button.setAttributedTitle(attributedTitle, for: .normal)
        if let image = image {
            button.setImage(image, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        }
        button.addTarget(self, action: action, for: .touchUpInside)
        button.cornerDefault()
        return UIBarButtonItem(customView: button)
    }
}
