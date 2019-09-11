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

    func dismissOnMoveBackwards()
    func createToBeVision(_ toBeVision: QDMToBeVision)
}

extension DecisionTreeViewControllerDelegate {
    func dismissOnMoveBackwards() {
        // noop: Making this method optional as not all TBV screens are using it
    }

    func createToBeVision(text: String, workAnswers: [String], homeAnswers: [String]) {
        // noop: Making this method optional as not all TBV screens are using it
    }
}

final class DecisionTreePageViewController: UIPageViewController, ScreenZLevelIgnore {}

final class DecisionTreeViewController: UIViewController, ScreenZLevel3 {

    struct NextQuestion {
        let question: QDMQuestion
        let extraAnswer: String?
        let filter: String?
        let selectedAnswers: [DecisionTreeModel.SelectedAnswer]
        let direction: UIPageViewController.NavigationDirection
        let animated: Bool
    }

    // MARK: - Properties
    weak var delegate: DecisionTreeViewControllerDelegate?
    var interactor: DecisionTreeInteractorInterface?
    private var pageController: DecisionTreePageViewController?
    private weak var questionnaireController: DecisionTreeQuestionnaireViewController?
    private var currentTargetId: Int = 0
    private var isMindsetShifterLastQuestion = false
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var pageControllerContainer: UIView!
    @IBOutlet private weak var dotsLoadingView: DotsLoadingView!
    private var navigationButton: NavigationButton?
    private lazy var permissionView = PermissionCalendarView.instantiateFromNib()
    private var nextQuestion: NextQuestion?

    private lazy var editEventHandler: EditEventHandler = {
        let delegate = EditEventHandler()
        delegate.handler = { [weak self] (controller, action) in
            switch action {
            case .saved:
                if let ekEvent = controller.event {
                    controller.dismiss(animated: true)
                    let selectedEvent = QDMUserCalendarEvent(event: ekEvent)
                    self?.interactor?.setUserCalendarEvent(event: selectedEvent)
                    self?.trackUserEvent(.EDIT,
                                         stringValue: selectedEvent.qotId,
                                         valueType: .CALENDAR_EVENT,
                                         action: .KEYBOARD)
                    self?.interactor?.loadEventQuestion()
                }
            case .canceled, .deleted:
                controller.dismiss(animated: true)
            }
        }
        return delegate
    }()

    private lazy var isOnboardingDecisionTree: Bool = {
        if case .mindsetShifterTBVOnboarding? = interactor?.type {
            return true
        }
        return false
    }()

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
        interactor?.viewDidLoad()
        addObservers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        baseRootViewController?.shouldMoveBottomBarWithKeyboard = true
        trackPage()
        updateNavigationItems()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didTabDismiss),
                                               name: .didTabDismissBottomNavigation,
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        baseRootViewController?.shouldMoveBottomBarWithKeyboard = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController?.view.frame = pageControllerContainer.frame
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .didTabDismissBottomNavigation, object: nil)
    }
}

// MARK: - Private
private extension DecisionTreeViewController {
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(animateNavigationButton),
                                               name: .didUpdateSelectionCounter,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateBottomNavigationItems(_:)),
                                               name: .questionnaireBottomNavigationUpdate,
                                               object: nil)
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .questionnaireBottomNavigationUpdate, object: nil)
        NotificationCenter.default.removeObserver(self, name: .didUpdateSelectionCounter, object: nil)
    }

    @objc func updateBottomNavigationItems(_ notification: NSNotification) {
        guard let navigationButton = notification.object as? NavigationButton else { return }
        navigationButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        self.navigationButton = navigationButton
        updateNavigationItems()
    }

    func updateNavigationItems() {
        let leftItems = interactor?.hasLeftBarButtonItem == true ? [dismissNavigationItem()] : []
        var rightItems = [UIBarButtonItem]()
        if let navigationButton = navigationButton {
            rightItems = [UIBarButtonItem(from: navigationButton)]
        }
        updateBottomNavigation(leftItems, rightItems)
    }

    func resetNavigationItems() {
        let leftItems = [dismissNavigationItem()]
        updateBottomNavigation(leftItems, [])
    }

    @objc func animateNavigationButton() {
        navigationButton?.pulsate()
    }

    func setupPageViewController() {
        let pageController = DecisionTreePageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
        pageController.view.backgroundColor = interactor?.type.backgroundColor ?? .sand
        addChildViewController(pageController)
        view.insertSubview(pageController.view, aboveSubview: pageControllerContainer)
        pageController.setViewControllers([UIViewController()], direction: .forward, animated: false, completion: nil)
        self.pageController = pageController
    }

    func setupTypingAnimation() {
        dotsLoadingView.configure(dotsColor: interactor?.type.dotsColor)
        dotsLoadingView.startAnimation()
    }
}

// MARK: - Actions
private extension DecisionTreeViewController {
    @objc func didTabDismiss() {
        setShouldEndEditingTrue()
        dismiss()
        removeObservers()
        resetNavigationItems()
    }

    @IBAction func didTapPrevious(_ sender: UIButton) {
        if isOnboardingDecisionTree, let page = interactor?.pageDisplayed, page == 0 {
            delegate?.dismissOnMoveBackwards()
            return
        }
        trackUserEvent(.PREVIOUS, action: .TAP)
        moveBackward()
    }

    @IBAction func didTapContinue() {
        setShouldEndEditingTrue()
        interactor?.didTapContinue()
        if isOnboardingDecisionTree, let tbv = interactor?.createdToBeVision {
            delegate?.createToBeVision(tbv)
        }
    }

    @objc func didTapStartSprint() {
        interactor?.didTapStartSprint()
    }
}

// MARK: - DecisionTreeViewControllerInterface
extension DecisionTreeViewController: DecisionTreeViewControllerInterface {
    func dismiss() {
        interactor?.deleteModelIfNeeded()
        trackUserEvent(.CLOSE, action: .TAP)
        delegate?.didDismiss()
        dismiss(animated: true)
    }

    func trackUserEvent(_ answer: QDMAnswer?, _ name: QDMUserEventTracking.Name, _ valueType: QDMUserEventTracking.ValueType?) {
        trackUserEvent(name, value: answer?.remoteID, valueType: valueType, action: .TAP)
    }

    func setupView() {
        view.backgroundColor = interactor?.type.backgroundColor
        setupTypingAnimation()
        setupPageViewController()
    }

    func showQuestion(_ question: QDMQuestion,
                      extraAnswer: String?,
                      filter: String?,
                      selectedAnswers: [DecisionTreeModel.SelectedAnswer],
                      direction: UIPageViewController.NavigationDirection,
                      animated: Bool) {
        nextQuestion = NextQuestion(question: question,
                                    extraAnswer: extraAnswer,
                                    filter: filter,
                                    selectedAnswers: selectedAnswers,
                                    direction: direction,
                                    animated: animated)
        previousButton.isHidden = QuestionKey.preiviousButtonIsHidden(question.key) && !isOnboardingDecisionTree
        if question.answerType == AnswerType.openCalendarEvents.rawValue,
            let permissionType = interactor?.getCalendarPermissionType() {
            presentPermissionView(permissionType)
        } else {
            loadNextQuestion(nextQuestion)
        }
    }

    func toBeVisionDidChange() {
        delegate?.toBeVisionDidChange()
    }
}

// MARK: - Private
private extension DecisionTreeViewController {
    func loadNextQuestion(_ nextQuestion: NextQuestion?) {
        guard let next = nextQuestion else { return }
        if let dotsLoadingView = self.dotsLoadingView {
            dotsLoadingView.stopAnimation(nil)
        }
        let controller = self.questionnaireController(for: next.question,
                                                      extraAnswer: next.extraAnswer,
                                                      filter: next.filter,
                                                      selectedAnswers: next.selectedAnswers)
        self.pageController?.setViewControllers([controller],
                                                direction: next.direction,
                                                animated: true,
                                                completion: nil)
        self.questionnaireController = controller
    }

    func getQuestionTitleUpdate(_ selectedAnswers: [DecisionTreeModel.SelectedAnswer]) -> String? {
        switch interactor?.type {
        case .recovery?:
            let answers = selectedAnswers.compactMap { $0.answer }
            return AnswerKey.Recovery.identifyFatigueSympton(answers).replacement
        default: return nil
        }
    }

    func questionnaireController(for question: QDMQuestion,
                                 extraAnswer: String?,
                                 filter: String?,
                                 selectedAnswers: [DecisionTreeModel.SelectedAnswer])
        -> DecisionTreeQuestionnaireViewController {
            let controller = DecisionTreeQuestionnaireViewController(for: question,
                                                                     with: selectedAnswers,
                                                                     extraAnswer: extraAnswer,
                                                                     maxPossibleSelections: question.maxPossibleSelections ?? 0,
                                                                     answersFilter: filter,
                                                                     questionTitleUpdate: getQuestionTitleUpdate(selectedAnswers),
                                                                     preparations: interactor?.preparations(),
                                                                     isOnboarding: isOnboardingDecisionTree)
            controller.delegate = self
            controller.interactor = interactor
            questionnaireController = controller
            return controller
    }
}

// MARK: - Update UI
private extension DecisionTreeViewController {
    func moveBackward() {
        if let previousQuestion = interactor?.previousQuestion() {
            setShouldEndEditingTrue()
            var extraAnswer = interactor?.extraAnswer
            if previousQuestion.key == QuestionKey.ToBeVision.Create {
                extraAnswer = interactor?.createdToBeVision?.text
            }
            showQuestion(previousQuestion,
                         extraAnswer: extraAnswer,
                         filter: interactor?.answersFilter,
                         selectedAnswers: interactor?.selectedanswers ?? [],
                         direction: .reverse,
                         animated: false)
        }
    }

    func setShouldEndEditingTrue() {
        guard let questionnaireController = self.pageController?.viewControllers?.first as? DecisionTreeQuestionnaireViewController,
            let userInputCell = questionnaireController.getUserInputCell() else {
                return
        }
        userInputCell.shouldEndEditing = true
    }
}

// MARK: - navigation bar
extension DecisionTreeViewController {
    override func showTransitionBackButton() -> Bool {
        return false
    }
}

// MARK: - DecisionTreeQuestionnaireDelegate
extension DecisionTreeViewController: DecisionTreeQuestionnaireDelegate {
    func presentSprints() {
        //TODO
        dismiss()
    }

    func presentTrackTBV() {
        //TODO
        dismiss()
    }

    @objc func didPressDimissInfoView() {
        trackUserEvent(.CLOSE,
                       value: interactor?.selectedSprint?.remoteID,
                       stringValue: interactor?.selectedSprintTitle,
                       valueType: .CONTENT,
                       action: .PRESS)
    }

    @objc func didPressDimiss() {
        setShouldEndEditingTrue()
        dismiss()
    }

    @objc func didPressContinue() {
        setShouldEndEditingTrue()
        if isOnboardingDecisionTree, let tbv = interactor?.createdToBeVision {
            delegate?.createToBeVision(tbv)
        }
        interactor?.didTapContinue()
    }

    func didUpdateUserInput(_ userInput: String?) {
        trackUserEvent(.ANSWER, stringValue: userInput, valueType: .USER_INPUT, action: .KEYBOARD)
        interactor?.userInput = userInput
    }

    func didTapBinarySelection(_ answer: QDMAnswer) {
        interactor?.handleSingleSelection(for: answer)
    }

    func didSelectAnswer(_ answer: QDMAnswer) {
        interactor?.didSelectAnswer(answer)
    }

    func didDeSelectAnswer(_ answer: QDMAnswer) {
        interactor?.didDeSelectAnswer(answer)
    }

    func textCellDidAppear(targetID: Int, questionKey: String?) {
        if currentTargetId != targetID {
            currentTargetId = targetID
            DispatchQueue.main.asyncAfter(deadline: .now() + Animation.duration_3) {
                NotificationCenter.default.post(name: .typingAnimationStart, object: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + Animation.duration_3) {
                    self.interactor?.loadNextQuestion(targetId: targetID, animated: true)
                }
            }
        } else {
            if questionKey == QuestionKey.MindsetShifter.Last {
                isMindsetShifterLastQuestion = true
            }
        }
    }

    func didSelectCalendarEvent(_ event: QDMUserCalendarEvent, selectedAnswer: QDMAnswer) {
        interactor?.setUserCalendarEvent(event: event)
        trackUserEvent(.SELECT, stringValue: event.qotId, valueType: .CALENDAR_EVENT, action: .TAP)
        interactor?.loadNextQuestion(from: selectedAnswer)
    }

    func didSelectPreparation(_ prepartion: QDMUserPreparation) {
        interactor?.openPrepareResults(prepartion, [])
    }

    func presentAddEventController(_ eventStore: EKEventStore) {
        let eventEditVC = EKEventEditViewController()
        eventEditVC.eventStore = eventStore
        eventEditVC.editViewDelegate = editEventHandler
        present(eventEditVC, animated: true)
    }

    func presentInfoView(icon: UIImage?, title: String?, text: String?) {
        trackUserEvent(.OPEN,
                       value: interactor?.selectedSprint?.remoteID,
                       stringValue: interactor?.selectedSprintTitle,
                       valueType: .CONTENT,
                       action: .PRESS)
        let cancelButtonItem = roundedBarButtonItem(title: ScreenTitleService.main.localizedString(for: .ButtonTitleCancel),
                                                     buttonWidth: .Cancel,
                                                     action: #selector(didPressDimissInfoView),
                                                     backgroundColor: .carbonDark,
                                                     borderColor: .accent40)
        let continueButtonItem = roundedBarButtonItem(title: R.string.localized.alertButtonTitleContinue(),
                                                     buttonWidth: .Continue,
                                                     action: #selector(didTapStartSprint),
                                                     backgroundColor: .carbonDark,
                                                     borderColor: .accent40)
        QOTAlert.show(title: title, message: text, bottomItems: [cancelButtonItem, continueButtonItem])
    }

    func presentPermissionView(_ permissionType: AskPermission.Kind) {
        if let controller = R.storyboard.askPermission().instantiateInitialViewController() as? AskPermissionViewController {
            AskPermissionConfigurator.make(viewController: controller, type: permissionType)
            present(controller, animated: true, completion: nil)
        }
    }
}

private class EditEventHandler: NSObject, EKEventEditViewDelegate {
    var handler: ((EKEventEditViewController, EKEventEditViewAction) -> Void)?

    func eventEditViewController(_ controller: EKEventEditViewController,
                                 didCompleteWith action: EKEventEditViewAction) {
        handler?(controller, action)
    }
}

// MARK: - SolveResultsViewControllerDelegate
extension DecisionTreeViewController: SolveResultsViewControllerDelegate {
    func didFinishSolve() {
        dismiss()
    }

    func didFinishRec() {
        trackUserEvent(.CLOSE, action: .TAP)
        delegate?.didDismiss()
        dismiss(animated: true)
    }
}
