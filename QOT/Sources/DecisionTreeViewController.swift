//
//  DecisionTreeViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DecisionTreeViewController: UIViewController {

    // MARK: - Properties

    var interactor: DecisionTreeInteractorInterface?
    private var extraAnswer: String? = ""
    private var pageController: UIPageViewController?
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var pageControllerContainer: UIView!
    @IBOutlet private weak var dotsLoadingView: DotsLoadingView!
    @IBOutlet private weak var continueButton: DecisionTreeButton!
    @IBOutlet private weak var continueButtonWidth: NSLayoutConstraint!
    @IBOutlet private weak var bottomViewContainer: UIView!

    private var selectedAnswers: [Answer] {
        return decisionTree?.selectedAnswers.map { $0.answer } ?? []
    }

    private var currentQuestion: Question? {
        return decisionTree?.questions[pageIndex]
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController?.view.frame = pageControllerContainer.frame
    }
}

// MARK: - Private

private extension DecisionTreeViewController {

    func setupView() {
        continueButtonWidth.constant += view.bounds.width * 0.025
        continueButton.corner(radius: continueButton.bounds.height / 2)
        continueButton.configure(with: defaultButtonText,
                                 selectedBackgroundColor: .carbonDark,
                                 defaultBackgroundColor: .carbon05,
                                 borderColor: .clear,
                                 titleColor: .accent,
                                 maxPossibleSelections: currentQuestion?.maxPossibleSelections)
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
        pageController?.view.backgroundColor = .sand
        if let pageController = pageController {
            addChildViewController(pageController)
            view.insertSubview(pageController.view, aboveSubview: pageControllerContainer)
        }
    }

    func showFirstQuestion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Animation.duration_1_5) { [unowned self] in
            self.dotsLoadingView.stopAnimation()
            if let firstQuestion = self.decisionTree?.questions.first {
                let firstQuestionnaireVC = self.questionnaireController(for: firstQuestion)
                self.pageController?.setViewControllers([firstQuestionnaireVC],
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
        moveBackward()
        updateMultipleSelectionCounter()
    }

    @IBAction func didTapClose(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func didTapContinue(_ sender: UIButton) {
        if currentQuestion?.answerType == AnswerType.lastQuestion.rawValue ||
            currentQuestion?.key == QuestionKey.MindsetShifterTBV.review.rawValue {
            dismiss(animated: true, completion: nil)
        } else {
            switch currentQuestion?.key {
            case QuestionKey.MindsetShifter.openTBV.rawValue: interactor?.openShortTBVGenerator()
            case QuestionKey.MindsetShifter.check.rawValue: interactor?.openMindsetShifterChecklist(from: selectedAnswers)
            default: break
            }
            moveForward()
            updateMultipleSelectionCounter()
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
             AnswerType.yesOrNo.rawValue:
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
        let controller = DecisionTreeQuestionnaireViewController(for: question,
                                                                 with: selectedAnswers,
                                                                 extraAnswer: extraAnswer,
                                                                 maxPossibleSelections: question.maxPossibleSelections)
        controller.delegate = self
        return controller
    }

    func loadNextQuestion(from answer: Answer) {
        if let nextQuestionID = answer.decisions.last(where: { $0.targetType == TargetType.question.rawValue })?.targetID {
            if decisionTree?.questions.filter ({ $0.remoteID.value == nextQuestionID }).isEmpty ?? false {
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
        case AnswerType.multiSelection.rawValue:
            let selectionIsCompleted = multiSelectionCounter == maxPossibleSelections
            continueButton.backgroundColor = selectionIsCompleted ? .carbonDark : .carbon05
            continueButton.isUserInteractionEnabled = selectionIsCompleted
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
            let nextQuestionnaireVC = questionnaireController(for: nextQuestion)
            self.pageController?.setViewControllers([nextQuestionnaireVC],
                                                    direction: .forward,
                                                    animated: true,
                                                    completion: nil)
        }
        pageIndex.plus(1)
    }

    func moveBackward() {
        if let previousQuestion = previousQuestion() {
            let previousQuestionnaireVC = questionnaireController(for: previousQuestion)
            self.pageController?.setViewControllers([previousQuestionnaireVC],
                                                    direction: .reverse,
                                                    animated: true,
                                                    completion: nil)
        }
        pageIndex.minus(1)
    }

    func updateBottomButtonTitle() {
        guard
            let questionKey = currentQuestion?.key,
            let answerType = currentQuestion?.answerType else { return }
        switch answerType {
        case AnswerType.multiSelection.rawValue:
            continueButton.update(with: multiSelectionCounter,
                                  defaultTitle: defaultButtonText,
                                  confirmationTitle: confirmationButtonText,
                                  questionKey: questionKey,
                                  maxSelections: maxPossibleSelections)
        default:
            continueButton.setTitle(confirmationButtonText, for: .normal)
        }
    }
}

// MARK: - DecisionTreeQuestionnaireDelegate

extension DecisionTreeViewController: DecisionTreeQuestionnaireDelegate {

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
}

// MARK: - Handling selections

private extension DecisionTreeViewController {

    func handleSingleSelection(for answer: Answer) {
        guard let questionID = currentQuestion?.remoteID.value else { return }
        let selectedAnswer = DecisionTreeModel.SelectedAnswer(questionID: questionID, answer: answer)
        decisionTree?.add(selectedAnswer)
        if let contentID = answer.decisions.first(where: { $0.targetType == TargetType.content.rawValue })?.targetID {
            if answer.keys.contains(AnswerKey.Prepare.openCheckList.rawValue) {
                interactor?.openPrepareChecklist(with: contentID)
            } else {
                interactor?.displayContent(with: contentID)
            }
        }
        if let contentItemID = answer.decisions.first(where: { $0.targetType == TargetType.contentItem.rawValue })?.targetID {
            interactor?.streamContentItem(with: contentItemID)
        }
        if answer.keys.contains(AnswerKey.ToBeVision.uploadImage.rawValue) {
            interactor?.uploadPhoto()
        }
        if let targetID = answer.decisions.first(where: { $0.targetType == TargetType.question.rawValue })?.targetID {
            interactor?.loadNextQuestion(from: targetID, selectedAnswers: selectedAnswers)
        }
    }

    func handleMultiSelection(for answer: Answer) {
        guard let questionID = currentQuestion?.remoteID.value else { return }
        let selection = DecisionTreeModel.SelectedAnswer(questionID: questionID, answer: answer)
        decisionTree?.addOrRemove(selection, addCompletion: {
            if multiSelectionCounter < maxPossibleSelections {
                multiSelectionCounter.plus(1)
            }
            if multiSelectionCounter == maxPossibleSelections {
                DispatchQueue.main.async {
                    self.loadNextQuestion(from: answer)
                }
            }
        }, removeCompletion: {
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
}
