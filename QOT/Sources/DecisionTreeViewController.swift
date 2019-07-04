//
//  DecisionTreeViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import qot_dal

protocol DecisionTreeViewControllerDelegate: class {
    func toBeVisionDidChange()
    func didDismiss()
}

final class DecisionTreeViewController: UIViewController {

    // MARK: - Properties

    weak var delegate: DecisionTreeViewControllerDelegate?
    var interactor: DecisionTreeInteractorInterface?
    private var prepareEventType: String = ""
    private var extraAnswer: String? = ""
    private var pageController: UIPageViewController?
    private var selectedEvent = QDMUserCalendarEvent()
    private var tempPageViewControllerHeight = CGFloat(0)
    private var tempButtonTitle = ""
    private var recoveryFatigueType: AnswerKey.Recovery? = nil
    private var continueButton = DecisionTreeButton(type: .custom)
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var pageControllerContainer: UIView!
    @IBOutlet private weak var dotsLoadingView: DotsLoadingView!

    private lazy var editEventHandler: EditEventHandler = {
        let delegate = EditEventHandler()
        delegate.handler = { [weak self] (controller, action) in
            switch action {
            case .saved:
                if let ekEvent = controller.event {
                    controller.dismiss(animated: true)
                    self?.selectedEvent = QDMUserCalendarEvent(event: ekEvent)
                    self?.trackUserEvent(.EDIT,
                                         stringValue: self?.selectedEvent.qotId,
                                         valueType: .CALENDAR_EVENT,
                                         action: .KEYBOARD)
                    let eventQuestion = self?.decisionTree?.questions.filter {
                        $0.answerType == AnswerType.openCalendarEvents.rawValue
                    }.first
                    self?.loadNextQuestion(from: eventQuestion?.answers.first)
                }
            case .canceled, .deleted:
                controller.dismiss(animated: true)
            }
        }
        return delegate
    }()

    private var selectedAnswers: [Answer] {
        return decisionTree?.selectedAnswers.map { $0.answer } ?? []
    }

    private var currentQuestion: Question? {
        return decisionTree?.questions.at(index: pageIndex)
    }

    private var maxPossibleSelections: Int {
        return currentQuestion?.maxPossibleSelections ?? 0
    }

    private var defaultButtonText: String {
        return currentQuestion?.defaultButtonText ?? ""
    }

    private var confirmationButtonText: String {
        return currentQuestion?.confirmationButtonText ?? ""
    }

    private var pageIndex: Int = 0 {
        didSet {
            syncButtons()
        }
    }

    private var multiSelectionCounter: Int = 0 {
        didSet {
            syncButtons()
        }
    }

    private var decisionTree: DecisionTreeModel? {
        didSet {
            syncButtons()
        }
    }

    private var questionIsAnswered: Bool {
        guard decisionTree?.selectedAnswers.count ?? 0 > pageIndex else { return false }
        return decisionTree?.selectedAnswers
            .filter { $0.questionID == currentQuestion?.remoteID.value }
            .isEmpty == false
    }

    // MARK: - Init

    init(configure: Configurator<DecisionTreeViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        dotsLoadingView.configure(dotsColor: .carbonDark)
        dotsLoadingView.startAnimation()
        interactor?.viewDidLoad()
        setupView()
        showFirstQuestion()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController?.view.frame = pageControllerContainer.frame
    }
}

// MARK: - Private

private extension DecisionTreeViewController {
    func setupView() {
        setupContinueButton()
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
        pageController?.view.backgroundColor = .sand
        if let pageController = pageController {
            addChildViewController(pageController)
            view.insertSubview(pageController.view, aboveSubview: pageControllerContainer)
        }
    }

    func setupContinueButton() {
        continueButton.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: .decisionTreeButtonWidth,
                                                                                height: .buttonHeight))
        continueButton.cornerDefault()
        let attributedTitle = NSAttributedString(string: defaultButtonText,
                                                 letterSpacing: 0.2,
                                                 font: .sfProtextSemibold(ofSize: 14),
                                                 textColor: .carbon30)
        continueButton.configure(with: defaultButtonText,
                                 attributedTitle: attributedTitle,
                                 selectedBackgroundColor: .carbonDark,
                                 defaultBackgroundColor: .carbon05,
                                 borderColor: .clear,
                                 titleColor: .accent)
        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        updateBottomNavigation(rightItems: [continueButton.toBarButtonItem()])
    }

    func showFirstQuestion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Animation.duration_1_5) { [unowned self] in
            self.dotsLoadingView.stopAnimation()
            if let firstQuestion = self.decisionTree?.questions.first {
                self.pageController?.setViewControllers([self.questionnaireController(for: firstQuestion)],
                                                        direction: .forward,
                                                        animated: true,
                                                        completion: nil)
            }
        }
    }
}

// MARK: - Actions

private extension DecisionTreeViewController {
    @IBAction func didTapPrevious(_ sender: UIButton) {
        trackUserEvent(.PREVIOUS, action: .TAP)
        moveBackward()
        updateMultipleSelectionCounter()
    }

    @IBAction func didTapClose() {
        interactor?.deleteModelIfNeeded()
        trackUserEvent(.CLOSE, action: .TAP)
        delegate?.didDismiss()
        dismiss(animated: true)
    }

    @objc func didTapContinue() {
        if let type = interactor?.type {
            switch type {
            case .recovery:
                if currentQuestion?.key == QuestionKey.Recovery.intro.rawValue {
                    recoveryFatigueType = AnswerKey.Recovery.identifyFatigueSympton(selectedAnswers)
                }
                if currentQuestion?.key == QuestionKey.Recovery.loading.rawValue {
                    trackUserEvent(.NEXT, action: .TAP)
                    interactor?.openRecoveryResults()
                    return
                }
            case .prepareIntensions:
                interactor?.updatePrepareIntentions(decisionTree?.selectedAnswers ?? [])
                trackUserEvent(.CLOSE, action: .TAP)
                dismiss(animated: true, completion: nil)
            case .prepareBenefits:
                interactor?.updatePrepareBenefits(interactor?.prepareBenefits ?? "")
                trackUserEvent(.CLOSE, action: .TAP)
                dismiss(animated: true, completion: nil)
            case .prepare:
                if currentQuestion?.key == QuestionKey.Prepare.calendarEventSelectionCritical.rawValue ||
                    currentQuestion?.key == QuestionKey.Prepare.calendarEventSelectionDaily.rawValue {
                    presentAddEventController(eventStore: EKEventStore.shared)
                }
            default: break
            }
        }
        if currentQuestion?.answerType == AnswerType.lastQuestion.rawValue ||
            currentQuestion?.key == QuestionKey.MindsetShifterTBV.review.rawValue {
            dismiss(animated: true, completion: nil)
        } else if currentQuestion?.key == QuestionKey.Prepare.benefitsInput.rawValue {
            guard let answer = currentQuestion?.answers.first else { return }
            handleSingleSelection(for: answer)
        } else {
            switch currentQuestion?.key {
            case QuestionKey.MindsetShifter.openTBV.rawValue:
                interactor?.openShortTBVGenerator(completion: nil)
            case QuestionKey.MindsetShifter.check.rawValue:
                interactor?.openMindsetShifterChecklist(from: selectedAnswers)
            case QuestionKey.ToBeVision.create.rawValue,
                 QuestionKey.ToBeVision.review.rawValue:
                delegate?.toBeVisionDidChange()
            default: break
            }
            moveForward()
            updateMultipleSelectionCounter()
            trackUserEvent(.NEXT, action: .TAP)
        }
    }
}

// MARK: - DecisionTreeViewControllerInterface

extension DecisionTreeViewController: DecisionTreeViewControllerInterface {
    func load(_ decisionTree: DecisionTreeModel) {
        self.decisionTree = decisionTree
    }

    func loadNext(_ question: Question, with extraAnswer: String?) {
        decisionTree?.add(question)
        self.extraAnswer = extraAnswer
        switch currentQuestion?.answerType {
        case AnswerType.singleSelection.rawValue,
             AnswerType.yesOrNo.rawValue,
             AnswerType.openCalendarEvents.rawValue,
             AnswerType.uploadImage.rawValue:
            moveForward()
        default: return
        }
    }
}

// MARK: - Get questions

private extension DecisionTreeViewController {
    func previousQuestion() -> Question? {
        guard pageIndex > 0 else { return nil }
        return decisionTree?.questions[pageIndex.advanced(by: -1)]
    }

    func nextQuestion() -> Question? {
        guard
            let questionsCount = decisionTree?.questions.count,
            questionsCount > pageIndex.advanced(by: 1) else { return nil }
        return decisionTree?.questions[pageIndex.advanced(by: 1)]
    }

    func questionnaireController(for question: Question) -> DecisionTreeQuestionnaireViewController {
        let selectedAnswers = decisionTree?.selectedAnswers.filter { $0.questionID == question.remoteID.value } ?? []
        let filter = interactor?.answersFilter(currentQuestion: currentQuestion, decisionTree: decisionTree)
        let controller = DecisionTreeQuestionnaireViewController(for: question,
                                                                 with: selectedAnswers,
                                                                 extraAnswer: extraAnswer,
                                                                 maxPossibleSelections: question.maxPossibleSelections,
                                                                 answersFilter: filter,
                                                                 questionTitleUpdate: recoveryFatigueType?.replacement)
        controller.delegate = self
        controller.interactor = interactor
        return controller
    }

    func loadNextQuestion(from answer: Answer?) {
        if let nextQuestionID = answer?.decisions.last(where: {
            $0.targetType == TargetType.question.rawValue
        })?.targetID {
            if decisionTree?.questions.filter ({ $0.remoteID.value == nextQuestionID }).isEmpty ?? false {
                interactor?.loadNextQuestion(from: nextQuestionID, selectedAnswers: selectedAnswers)
            } else if let answer = answer {
                let selectedAnswer = DecisionTreeModel.SelectedAnswer(questionID: nextQuestionID, answer: answer)
                decisionTree?.add(selectedAnswer)
                interactor?.loadNextQuestion(from: nextQuestionID, selectedAnswers: selectedAnswers)
            }
        }
    }
}

// MARK: - Update UI

private extension DecisionTreeViewController {
    func syncButtons() {
        previousButton.isHidden = pageIndex == 0
        updateBottomButtonTitle()
        switch currentQuestion?.answerType {
        case AnswerType.singleSelection.rawValue,
             AnswerType.yesOrNo.rawValue,
             AnswerType.uploadImage.rawValue:
            continueButton.isHidden = questionIsAnswered == false
            continueButton.isUserInteractionEnabled = true
            continueButton.backgroundColor = .carbonDark
            updateBottomNavigation(rightItems: [continueButton.toBarButtonItem()])
        case AnswerType.multiSelection.rawValue:
            let selectionIsCompleted = multiSelectionCounter == maxPossibleSelections
            continueButton.setTitleColor(selectionIsCompleted ? .red : .red, for: .normal)
            continueButton.backgroundColor = selectionIsCompleted ? .carbonDark : .carbon05
            continueButton.isUserInteractionEnabled = selectionIsCompleted
            continueButton.isHidden = false
            updateBottomNavigation(rightItems: [continueButton.toBarButtonItem()])
        default: return
        }
    }

    func updateMultipleSelectionCounter() {
        if currentQuestion?.answerType == AnswerType.multiSelection.rawValue {
            multiSelectionCounter = decisionTree?.selectedAnswers
                .filter { $0.questionID == currentQuestion?.remoteID.value }
                .count ?? 0
        }
    }

    func moveForward() {
        if let nextQuestion = nextQuestion() {
            pageController?.setViewControllers([questionnaireController(for: nextQuestion)],
                                               direction: .forward,
                                               animated: true,
                                               completion: { _ in
                                                if nextQuestion.answerType == AnswerType.userInput.rawValue {
                                                    self.view.becomeFirstResponder()
                                                }
            })
            pageIndex.plus(1)
        }
    }

    func moveBackward() {
        if let previousQuestion = previousQuestion() {
            self.pageController?.setViewControllers([questionnaireController(for: previousQuestion)],
                                                    direction: .reverse,
                                                    animated: true,
                                                    completion: nil)
        }
        pageIndex.minus(1)
    }

    func updateBottomButtonTitle() {
        guard let answerType = currentQuestion?.answerType else { return }
        switch answerType {
        case AnswerType.multiSelection.rawValue:
            continueButton.update(with: multiSelectionCounter,
                                  defaultTitle: defaultButtonText,
                                  confirmationTitle: confirmationButtonText,
                                  maxSelections: maxPossibleSelections)
            updateBottomNavigation(rightItems: [continueButton.toBarButtonItem()])
        case AnswerType.text.rawValue,
              AnswerType.openCalendarEvents.rawValue:
            continueButton.isHidden = false
            continueButton.setTitle(defaultButtonText, for: .normal)
            updateBottomNavigation(rightItems: [continueButton.toBarButtonItem()])
        default:
            tempButtonTitle = confirmationButtonText
            refreshBottomNavigationItems()
            continueButton.setTitle(confirmationButtonText, for: .normal)
            updateBottomNavigation(rightItems: [continueButton.toBarButtonItem()])
        }
    }

    func updateBottomNavigation(rightItems: [UIBarButtonItem]) {
        let navigationItem = BottomNavigationItem(leftBarButtonItems: [dismissNavigationItem()],
                                                  rightBarButtonItems: rightItems,
                                                  backgroundColor: .clear)
        NotificationCenter.default.post(name: .updateBottomNavigation, object: navigationItem)
    }
}

// MARK: - DecisionTreeQuestionnaireDelegate

extension DecisionTreeViewController: DecisionTreeQuestionnaireDelegate {
    func didPressDimiss() {
        didTapClose()
    }

    func didPressContinue() {
        didTapContinue()
    }

    func didUpdatePrepareBenefits(_ benefits: String?) {
        trackUserEvent(.ANSWER, stringValue: benefits, valueType: .USER_INPUT, action: .KEYBOARD)
        interactor?.prepareBenefits = benefits
    }

    func didTapBinarySelection(_ answer: Answer) {
        handleSingleSelection(for: answer)
    }

    func textCellDidAppear(targetID: Int) {
        interactor?.loadNextQuestion(from: targetID, selectedAnswers: selectedAnswers)
    }

    func didTapMultiSelection(_ answer: Answer) {
        switch currentQuestion?.answerType {
        case AnswerType.multiSelection.rawValue: handleMultiSelection(for: answer)
        case AnswerType.singleSelection.rawValue: handleSingleSelection(for: answer)
        default: break
        }
        interactor?.notifyCounterChanged(with: multiSelectionCounter, selectedAnswers: selectedAnswers)
    }

    func didSelectCalendarEvent(_ event: QDMUserCalendarEvent, selectedAnswer: Answer) {
        selectedEvent = event
        trackUserEvent(.SELECT, stringValue: event.qotId, valueType: .CALENDAR_EVENT, action: .TAP)
        loadNextQuestion(from: selectedAnswer)
    }

    func presentAddEventController(eventStore: EKEventStore) {
        let eventEditVC = EKEventEditViewController()
        eventEditVC.eventStore = eventStore
        eventEditVC.editViewDelegate = editEventHandler
        present(eventEditVC, animated: true)
    }
}

private class EditEventHandler: NSObject, EKEventEditViewDelegate {
    var handler: ((EKEventEditViewController, EKEventEditViewAction) -> Void)?

    func eventEditViewController(_ controller: EKEventEditViewController,
                                 didCompleteWith action: EKEventEditViewAction) {
        handler?(controller, action)
    }
}

// MARK: - Handling selections

private extension DecisionTreeViewController {
    func handleSingleSelection(for answer: Answer) {
        guard let questionID = currentQuestion?.remoteID.value else { return }
        updateDecisionTree(answer, questionID)
        trackUserEvent(answer, .SELECT, .ANSWER_DECISION)

        if answer.keys.contains(AnswerKey.Prepare.eventTypeSelectionCritical.rawValue) {
            prepareEventType = answer.title
        }

        if answer.keys.contains(AnswerKey.Solve.openVisionPage.rawValue) {
            interactor?.openToBeVisionPage()
            return
        }
        if currentQuestion?.key == QuestionKey.Solve.help.rawValue ||
            answer.keys.contains(AnswerKey.Solve.letsDoIt.rawValue) {
            interactor?.openSolveResults(from: answer, type: .solve)
            return
        }
        if currentQuestion?.key == QuestionKey.Prepare.eventTypeSelectionCritical.rawValue {
            interactor?.setTargetContentID(for: answer)
        } else if currentQuestion?.key == QuestionKey.Recovery.syntom.rawValue {
            interactor?.updateRecoveryModel(fatigueAnswerId: currentQuestion?.answers.first?.remoteID.value ?? 0,
                                            answer.remoteID.value ?? 0,
                                            answer.targetId(.content) ?? 0)
        } else if let contentId = answer.targetId(.content) {
            showResultView(for: answer, contentID: contentId)
        }
        if let contentItemID = answer.targetId(.contentItem) {
            interactor?.streamContentItem(with: contentItemID)
        }
        if answer.keys.contains(AnswerKey.ToBeVision.uploadImage.rawValue) {
            interactor?.openImagePicker()
        }
        if let targetQuestionId = answer.targetId(.question) {
            if currentQuestion?.key == QuestionKey.Prepare.buildCritical.rawValue {
                if interactor?.userHasToBeVision == false {
                    interactor?.openShortTBVGenerator { [weak self] in
                        self?.interactor?.loadNextQuestion(from: Prepare.Key.perceived.questionID,
                                                           selectedAnswers: self?.selectedAnswers ?? [])
                    }
                } else {
                    interactor?.loadNextQuestion(from: targetQuestionId, selectedAnswers: self.selectedAnswers)
                }
            } else {
                interactor?.loadNextQuestion(from: targetQuestionId, selectedAnswers: selectedAnswers)
            }
        }
    }

    func handleMultiSelection(for answer: Answer) {
        guard let questionID = currentQuestion?.remoteID.value else { return }
        let selection = DecisionTreeModel.SelectedAnswer(questionID: questionID, answer: answer)
        decisionTree?.addOrRemove(selection, addCompletion: {
            trackUserEvent(answer, .SELECT, .ANSWER_DECISION)
            if multiSelectionCounter < maxPossibleSelections {
                multiSelectionCounter.plus(1)
            }
            if multiSelectionCounter == maxPossibleSelections {
                DispatchQueue.main.async {
                    self.loadNextQuestion(from: answer)
                }
            }
            if let remoteID = answer.remoteID.value {
                trackUserEvent(.SELECT, value: remoteID, valueType: .ANSWER_DECISION, action: .TAP)
            }
        }, removeCompletion: {
            trackUserEvent(answer, .DESELECT, .ANSWER_DECISION)
            if multiSelectionCounter == maxPossibleSelections {
                DispatchQueue.main.async {
                    self.decisionTree?.removeLastQuestion()
                }
            }
            if multiSelectionCounter > 0 {
                multiSelectionCounter.minus(1)
            }
        })
        continueButton.pulsate()
    }

    func shouldShowAddNewEventView() -> Bool {
        let answerKeys = decisionTree?.selectedAnswers.flatMap { $0.answer.keys }
        return answerKeys?.contains(AnswerKey.Prepare.eventTypeSelectionDaily.rawValue) == true ||
            answerKeys?.contains(AnswerKey.Prepare.eventTypeSelectionCritical.rawValue) == true
    }
}

// MARK: - Private

private extension DecisionTreeViewController {
    func showResultView(for answer: Answer, contentID: Int) {
        if answer.keys.contains(AnswerKey.Prepare.openCheckList.rawValue) {
            interactor?.openPrepareResults(contentID)
        } else if currentQuestion?.key == QuestionKey.Prepare.eventTypeSelectionDaily.rawValue {
            let level = QDMUserPreparation.Level.LEVEL_DAILY
            PreparationManager.main.create(level: level,
                                           contentCollectionId: level.contentID,
                                           relatedStrategyId: answer.decisions.first?.targetID ?? 0,
                                           eventType: answer.title,
                                           event: selectedEvent) { [weak self] (preparation) in
                                            if let preparation = preparation {
                                                self?.interactor?.openPrepareResults(preparation,
                                                                                     self?.decisionTree?.selectedAnswers ?? [])
                                            }
            }
        } else if currentQuestion?.key == QuestionKey.Prepare.benefitsInput.rawValue {
            let level = QDMUserPreparation.Level.LEVEL_CRITICAL
            PreparationManager.main.create(level: level,
                                           benefits: interactor?.prepareBenefits,
                                           answerFilter: interactor?.answersFilter(currentQuestion: nil,
                                                                                   decisionTree: nil),
                                           contentCollectionId: level.contentID,
                                           relatedStrategyId: answer.decisions.first?.targetID ?? 0,
                                           strategyIds: [interactor?.relatedStrategyID ?? 0],
                                           eventType: prepareEventType,
                                           event: selectedEvent) { [weak self] (preparation) in
                                            if let preparation = preparation {
                                                self?.interactor?.openPrepareResults(preparation,
                                                                                     self?.decisionTree?.selectedAnswers ?? [])
                                            }
            }
        } else {
            interactor?.displayContent(with: contentID)
        }
    }
}

// MARK: - Recovery

private extension DecisionTreeViewController {
    func handleSingleSelectionRecovery(for answer: Answer) {

    }
}

// MARK: - Track Event

private extension DecisionTreeViewController {
    func trackUserEvent(_ answer: Answer, _ name: QDMUserEventTracking.Name, _ valueType: QDMUserEventTracking.ValueType) {
        if let remoteID = answer.remoteID.value {
            trackUserEvent(name, value: remoteID, valueType: valueType, action: .TAP)
        }
    }
}

private extension DecisionTreeViewController {
    func updateDecisionTree(_ answer: Answer, _ questionID: Int) {
        let selectedAnswer = DecisionTreeModel.SelectedAnswer(questionID: questionID, answer: answer)
        decisionTree?.add(selectedAnswer)
    }
}

// MARK: - SolveResultsViewControllerDelegate

extension DecisionTreeViewController: SolveResultsViewControllerDelegate {

    func didFinishSolve() {
        dismiss(animated: true)
    }
}
