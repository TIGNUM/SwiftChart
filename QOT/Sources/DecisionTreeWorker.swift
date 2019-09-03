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
    private var prepareKey: Prepare.Key = .perceived
    private var _selectedAnswers: [DecisionTreeModel.SelectedAnswer] = []
    private var answerFilter: String?
    private var answerFilterMindset: String?
    private var _extraAnswer: String? = nil
    private var recoveryModel: QDMRecovery3D?
    internal var recoveryCauseAnswerId: Int?
    internal var recoveryCauseContentItemId: Int?
    internal var recoveryCauseContentId: Int?
    internal var visionText: String? = nil
    internal let type: DecisionTreeType
    internal var selectedEvent = QDMUserCalendarEvent()
    internal var prepareEventType: String = ""
    internal var questions: [QDMQuestion] = []
    internal var preparations: [QDMUserPreparation] = []
    internal var recoveryFatigueType: AnswerKey.Recovery? = nil
    internal var activeSprint: QDMSprint?
    internal var sprintToUpdate: QDMSprint?
    internal var newSprintContentId: Int?
    internal var lastSprintQuestionId: Int?
    internal var targetContentID: Int = 0
    internal var nextQuestionId: Int = 0
    internal var createdTBV: QDMToBeVision? // TBV cached during onboarding
    var continueButton = DecisionTreeButton(frame: .Default)
    weak var prepareDelegate: PrepareResultsDelegatge?
    weak var delegate: DecisionTreeViewControllerDelegate?
    var interactor: DecisionTreeInteractorInterface?

    private var currentExtendedQuestion: DecisionTreeModel.ExtendedQuestion? {
        return decisionTree?.extendedQuestions.last
    }

    internal var currentQuestion: QDMQuestion? {
        return currentExtendedQuestion?.question
    }

    internal var pageIndex: Int = 0 {
        didSet { multiSelectionCounter = 0 }
    }

    var decisionTree: DecisionTreeModel? {
        didSet { syncButtons() }
    }

    internal var multiSelectionCounter: Int = 0 {
        didSet { syncButtons() }
    }

    var eventQuestion: QDMQuestion? {
        return decisionTree?.extendedQuestions.filter {
            $0.question.answerType == AnswerType.openCalendarEvents.rawValue
            }.first?.question
    }

    var selectedSprintTitle: String {
        return selectedSprint?.subtitle ?? ""
    }

    var selectedSprint: QDMAnswer? {
        return decisionTree?.selectedAnswers.filter { $0.questionID == 100369 }.last?.answer
    }

    internal var maxPossibleSelections: Int {
        return currentQuestion?.maxPossibleSelections ?? 0
    }

    internal var decisionTreeAnswers: [QDMAnswer] {
        return decisionTree?.selectedAnswers.map { $0.answer } ?? []
    }

    internal var defaultButtonText: String {
        return currentQuestion?.defaultButtonText ?? ""
    }

    internal var confirmationButtonText: String {
        return currentQuestion?.confirmationButtonText ?? ""
    }

    internal var questionIsAnswered: Bool {
        guard decisionTree?.selectedAnswers.count ?? 0 > pageIndex else { return false }
        return decisionTree?.selectedAnswers
            .filter { $0.questionID == currentQuestion?.remoteID }
            .isEmpty == false
    }

    // MARK: - Init
    init(type: DecisionTreeType) {
        self.type = type
        switch type {
        case .sprintReflection(let sprint):
            sprintToUpdate = sprint
        case .prepare:
            getPreparations { [weak self] (preparations) in
                self?.preparations = preparations ?? []
            }
        default:
            break
        }
        addObserver()
        setupContinueButton()
    }
}

// MARK: - Public Vars
extension DecisionTreeWorker {
    var extraAnswer: String? {
        return _extraAnswer
    }
    var firstQuestion: QDMQuestion? {
        switch type {
        case .prepareIntentions,
             .prepareBenefits:
            return questions.first
        default:
            return decisionTree?.extendedQuestions.filter { $0.question.key == type.introKey }.first?.question
        }
    }

    var userHasToBeVision: Bool {
        return visionText != nil && visionText?.trimmed.isEmpty == false
    }

    var userInput: String? {
        get { return currentExtendedQuestion?.userInput }
        set { decisionTree?.update(currentQuestion, newValue) }
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
        if pageIndex.advanced(by: -1) >= 0 {
            pageIndex.minus(1)
            decisionTree?.removeLastQuestion()
            multiSelectionCounter = 0
            return decisionTree?.extendedQuestions[pageIndex].question
        }
        return nil
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
        if answerFilter != nil {
            let result = answerFilter
            answerFilter = nil
            return result
        }
        let keyFilter: DecisionTreeModel.Filter = .Relationship
        if currentQuestion?.key?.contains("prepare_peak_prep_") == true {
            return decisionTree?.selectedAnswers
                .compactMap { $0.answer }
                .flatMap { $0.keys }
                .filter { $0.contains(keyFilter) }
                .first
        }

        switch currentQuestion?.key {
        case QuestionKey.MindsetShifter.MoreInfo:
            return mindsetShifterFilter(keyFilter)
        case QuestionKey.MindsetShifter.GutReactions:
            return mindsetShifterFilter(keyFilter)
        case QuestionKey.MindsetShifter.LowPerformanceTalk:
            return answerFilterMindset
        default:
            break
        }
        return decisionTree?.selectedAnswers.first?.answer.keys.first(where: { $0.contains(keyFilter) })
    }

    func fetchQuestions(completion: @escaping () -> Void) {
        switch type {
        case .prepareIntentions(let selectedAnswers, let answerFilter, let key, let delegate):
            self.selectedAnswers = selectedAnswers
            self.multiSelectionCounter = selectedAnswers.count
            self.answerFilter = answerFilter
            self.prepareDelegate = delegate
            self.prepareKey = key
            qot_dal.QuestionService.main.question(with: key.rawValue, in: type.questionGroup) { [weak self] (question) in
                guard let question = question else { return }
                self?.questions = [question]
                self?.decisionTree = DecisionTreeModel(question: question)
                selectedAnswers.forEach { (selectedAnswer) in
                    self?.decisionTree?.add(selectedAnswer)
                }
                completion()
            }
        case .prepareBenefits(let benefits, let questionID, let delegate):
            self.userInput = benefits
            self.prepareDelegate = delegate
            qot_dal.QuestionService.main.question(with: questionID, in: type.questionGroup) { [weak self] (question) in
                guard let question = question else { return }
                self?.questions = [question]
                self?.decisionTree = DecisionTreeModel(question: question)
                completion()
            }
        default:
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
        case QuestionKey.ToBeVision.Create,
             QuestionKey.MindsetShifterTBV.Review:
            createVision(from: decisionTreeAnswers) { (vision) in
                completion((question, vision))
            }

        case QuestionKey.MindsetShifter.ShowTBV,
             QuestionKey.Prepare.ShowTBV:
            userService.getMyToBeVision { (vision, _, _) in
                completion((question, vision?.text))
            }

        default:
            completion((question, nil))
        }
    }

    /// Returns the media url for a specific content item
    func mediaURL(from contentItemID: Int, completion: @escaping (URL?, QDMContentItem?) -> Void) {
        qot_dal.ContentService.main.getContentItemById(contentItemID) { (item) in
            guard let urlString = item?.valueMediaURL else {
                completion(nil, nil)
                return
            }
            completion(URL(string: urlString), item)
        }
    }

    /// Saves `ImageResource`
    func save(_ image: UIImage) {
        switch type {
        case .toBeVisionGenerator, .mindsetShifterTBV, .mindsetShifterTBVOnboarding:
            saveToBeVision(image, completion: { (error) in
                if let error = error {
                    qot_dal.log(error.localizedDescription, level: .error)
                }
            })
        default: return
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
            if decisionTree?.extendedQuestions.filter({ $0.question.remoteID == question.remoteID }).isEmpty == true {
                decisionTree?.add(question)
                pageIndex.plus(1)
            }
        }
        if let answer = answer {
            let selectedAnswer = DecisionTreeModel.SelectedAnswer(questionID: questionId, answer: answer)
            decisionTree?.add(selectedAnswer)
        }
    }

    func createRecoveryModel(_ completion: @escaping (QDMRecovery3D?) -> Void) {
        let fatigueAnswerId = AnswerKey.Recovery.identifyFatigueSympton(decisionTreeAnswers).fatigueAnswerId
        qot_dal.ContentService.main.getContentCollectionById(recoveryCauseContentId ?? 0) { [weak self] (content) in
            let exclusiveContentIds = content?.relatedContentIdsRecoveryExclusive ?? []
            let suggestedContentIds = content?.suggestedContentIdsRecovery ?? []
            qot_dal.UserService.main.createRecovery3D(
                fatigueAnswerId: fatigueAnswerId,
                causeAnwserId: self?.recoveryCauseAnswerId ?? 0,
                causeContentItemId: self?.recoveryCauseContentItemId ?? 0,
                exclusiveContentCollectionIds: exclusiveContentIds,
                suggestedSolutionsContentCollectionIds: suggestedContentIds) { (recoveryModel, error) in
                    if let error = error {
                        qot_dal.log("Error while trying to CREATE QDMRecovery3D: \(error.localizedDescription)",
                            level: .debug)
                    }
                    self?.recoveryModel = recoveryModel
                    completion(recoveryModel)
            }
        }
    }
}

// MARK: - Private
private extension DecisionTreeWorker {
    func mindsetShifterFilter(_ keyFilter: String) -> String? {
        let selectedAnswerTitle = decisionTree?.selectedAnswers.last?.answer.subtitle?
            .replacingOccurrences(of: " ", with: "_") ?? ""
        let relationshipKeys = decisionTree?.selectedAnswers
            .compactMap { $0.answer }
            .flatMap { $0.keys }
            .filter { $0.contains(keyFilter) }
        answerFilterMindset = relationshipKeys?.filter { $0.contains(selectedAnswerTitle) }.first
        return answerFilterMindset
    }

    func setupContinueButton() {
        continueButton.cornerDefault()
        let attributedTitle = NSAttributedString(string: "",
                                                 letterSpacing: 0.2,
                                                 font: .sfProtextSemibold(ofSize: 14))
        continueButton.configure(with: "",
                                 attributedTitle: attributedTitle,
                                 selectedBackgroundColor: .carbonNew,
                                 defaultBackgroundColor: type.navigationButtonBackgroundColor,
                                 borderColor: .clear,
                                 titleColor: type.navigationButtonTextColor)
        continueButton.titleEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    }
}

// MARK: - Recovery3D
private extension DecisionTreeWorker {
    func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showNextQuestionDismiss),
                                               name: .willDismissPlayerController,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showNextQuestionDismiss),
                                               name: .didDismissMindsetResultView,
                                               object: nil)
    }

    func updateRecoveryModel(recovery: QDMRecovery3D?) {
        guard let recovery = recovery else { return }
        qot_dal.UserService.main.updateRecovery3D(recovery) { [weak self] (recovery, error) in
            if let error = error {
                qot_dal.log("Error while trying to UPDATE QDMRecovery3D: \(error.localizedDescription)",
                    level: .debug)
            }
            self?.recoveryModel = recovery
        }
    }

    func deleteRecoveryModel(_ recoveryModel: QDMRecovery3D?) {
        guard let recoveryModel = recoveryModel else { return }
        qot_dal.UserService.main.deleteRecovery3D(recoveryModel) { (error) in
            if let error = error {
                qot_dal.log("Error while trying to DELETE QDMRecovery3D: \(error.localizedDescription)",
                    level: .debug)
            }
        }
    }
}
