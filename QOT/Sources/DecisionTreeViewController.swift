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
    func createToBeVision(text: String, workAnswers: [String], homeAnswers: [String])
}

extension DecisionTreeViewControllerDelegate {
    func dismissOnMoveBackwards() {
        // noop: Making this method optional as not all TBV screens are using it
    }

    func createToBeVision(text: String, workAnswers: [String], homeAnswers: [String]) {
        // noop: Making this method optional as not all TBV screens are using it
    }
}

final class DecisionTreeViewController: UIViewController, ScreenZLevelBottom {

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
    private var pageController: UIPageViewController?
    private var continueButton = DecisionTreeButton(type: .custom)
    private var currentTargetId: Int = 0
    private var isMindsetShifterLastQuestion = false
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var pageControllerContainer: UIView!
    @IBOutlet private weak var dotsLoadingView: DotsLoadingView!
    @IBOutlet private weak var infoView: InfoHelperView!
    private lazy var permissionView = PermissionCalendarView.instantiateFromNib()
    private var nextQuestion: NextQuestion?
    @IBOutlet private weak var infoEffectContainerView: UIVisualEffectView!

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

    private lazy var leftNavigationItems: [UIBarButtonItem] = {
        let noDismissButton = isOnboardingDecisionTree || isMindsetShifterLastQuestion
        return noDismissButton ? [] : [dismissNavigationItem()]
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
        trackPage()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController?.view.frame = pageControllerContainer.frame
    }
}

// MARK: - Private
private extension DecisionTreeViewController {
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(animateNavigationButton),
                                               name: .didUpdateSelectionCounter,
                                               object: nil)
    }

    func setupPageViewController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
        pageController?.view.backgroundColor = interactor?.type.backgroundColor ?? .sand
        if let pageController = pageController {
            addChildViewController(pageController)
            view.insertSubview(pageController.view, aboveSubview: pageControllerContainer)
        }
    }

    func setupContinueButton() {
        continueButton.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: .DecisionTree, height: .Default))
        continueButton.cornerDefault()
        let attributedTitle = NSAttributedString(string: "",
                                                 letterSpacing: 0.2,
                                                 font: .sfProtextSemibold(ofSize: 14),
                                                 lineSpacing: 8)
        continueButton.configure(with: "",
                                 attributedTitle: attributedTitle,
                                 selectedBackgroundColor: .carbonDark,
                                 defaultBackgroundColor: interactor?.type.navigationButtonBackgroundColor ?? .carbon,
                                 borderColor: .clear,
                                 titleColor: interactor?.type.navigationButtonTextColor ?? .accent)
        continueButton.titleEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        updateBottomNavigation(leftItems: leftNavigationItems, rightItems: [continueButton.toBarButtonItem()])
    }

    func setupTypingAnimation() {
        dotsLoadingView.configure(dotsColor: interactor?.type.dotsColor)
        dotsLoadingView.startAnimation()
    }
}

// MARK: - Actions
private extension DecisionTreeViewController {
    @IBAction func didTapPrevious(_ sender: UIButton) {
        if isOnboardingDecisionTree, let page = interactor?.pageDisplayed, page == 0 {
            delegate?.dismissOnMoveBackwards()
            return
        }
        trackUserEvent(.PREVIOUS, action: .TAP)
        moveBackward()
    }

    @objc func didTapContinue() {
        interactor?.didTapContinue()
        if isOnboardingDecisionTree, let tbv = interactor?.createdToBeVision {
            delegate?.createToBeVision(text: tbv.text, workAnswers: tbv.workSelections, homeAnswers: tbv.homeSelections)
        }
    }

    @objc func didTapStartSprint() {
        infoView.isHidden = true
        infoEffectContainerView.isHidden = true
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
        setupContinueButton()
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
        if question.answerType == AnswerType.openCalendarEvents.rawValue {
            checkCalendarPermissions()
        } else {
            loadNextQuestion(nextQuestion)
        }
    }

    func syncButtons(previousButtonIsHidden: Bool, continueButtonIsHidden: Bool, backgroundColor: UIColor) {
        previousButton.isHidden = previousButtonIsHidden && !isOnboardingDecisionTree
        continueButton.isHidden = continueButtonIsHidden
        continueButton.isUserInteractionEnabled = !continueButtonIsHidden
        continueButton.backgroundColor = .sand
        updateBottomNavigation(leftItems: leftNavigationItems, rightItems: [continueButton.toBarButtonItem()])
    }

    func updateBottomButtonTitle(counter: Int, maxSelections: Int, defaultTitle: String?, confirmTitle: String?) {
        continueButton.update(with: counter,
                              defaultTitle: defaultTitle ?? "",
                              confirmationTitle: confirmTitle ?? "",
                              maxSelections: maxSelections,
                              titleColor: interactor?.type.navigationButtonTextColor)
        updateBottomNavigation(leftItems: leftNavigationItems, rightItems: [continueButton.toBarButtonItem()])
    }

    func toBeVisionDidChange() {
        delegate?.toBeVisionDidChange()
    }

    @objc func animateNavigationButton() {
        continueButton.pulsate()
    }

    func updateBottomNavigation(leftItems: [UIBarButtonItem], rightItems: [UIBarButtonItem]) {
        let navigationItem = BottomNavigationItem(leftBarButtonItems: leftItems,
                                                  rightBarButtonItems: rightItems,
                                                  backgroundColor: interactor?.type.backgroundColor ?? .clear)
        NotificationCenter.default.post(name: .updateBottomNavigation, object: navigationItem)
        baseRootViewController?.audioPlayerContainer.isHidden = true
    }
}

// MARK: - Private
private extension DecisionTreeViewController {
    func loadNextQuestion(_ nextQuestion: NextQuestion?) {
        guard let next = nextQuestion else { return }
        let deadline = DispatchTime.now() + (next.animated ? Animation.duration_1_5 : 0)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [unowned self] in
            if let dotsLoadingView = self.dotsLoadingView {
                dotsLoadingView.stopAnimation()
            }
            let controller = self.questionnaireController(for: next.question,
                                                          extraAnswer: next.extraAnswer,
                                                          filter: next.filter,
                                                          selectedAnswers: next.selectedAnswers)
            self.pageController?.setViewControllers([controller],
                                                    direction: next.direction,
                                                    animated: true,
                                                    completion: nil)
        }
    }

    func questionnaireController(for question: QDMQuestion,
                                 extraAnswer: String?,
                                 filter: String?,
                                 selectedAnswers: [DecisionTreeModel.SelectedAnswer])
        -> DecisionTreeQuestionnaireViewController {
            let answers = selectedAnswers.compactMap { $0.answer }
            let answerKey = AnswerKey.Recovery.identifyFatigueSympton(answers)
            let controller = DecisionTreeQuestionnaireViewController(for: question,
                                                                     with: selectedAnswers,
                                                                     extraAnswer: extraAnswer,
                                                                     maxPossibleSelections: question.maxPossibleSelections ?? 0,
                                                                     answersFilter: filter,
                                                                     questionTitleUpdate: answerKey.replacement,
                                                                     preparations: interactor?.preparations(),
                                                                     isOnboarding: isOnboardingDecisionTree)
            controller.delegate = self
            controller.interactor = interactor
            return controller
    }
}

// MARK: - Update UI
private extension DecisionTreeViewController {
    func moveBackward() {
        if let previousQuestion = interactor?.previousQuestion() {
            showQuestion(previousQuestion,
                         extraAnswer: interactor?.extraAnswer,
                         filter: interactor?.answersFilter,
                         selectedAnswers: interactor?.selectedanswers ?? [],
                         direction: .reverse,
                         animated: false)
        }
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
        let navigationItem = BottomNavigationItem(leftBarButtonItems: [],
                                                  rightBarButtonItems: [],
                                                  backgroundColor: .sand)
        NotificationCenter.default.post(name: .updateBottomNavigation, object: navigationItem)
        infoEffectContainerView.isHidden = true
    }

    @objc func didPressDimiss() {
        dismiss()
    }

    func didPressContinue() {
        didTapContinue()
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
                updateBottomNavigation(leftItems: [], rightItems: [continueButton.toBarButtonItem()])
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
        infoView.setBottomContentInset(BottomNavigationContainer.height)
        infoView.setTransparent(icon: icon, title: title, text: text)
        infoView.edges(to: view)
        infoView.isHidden = false
        infoEffectContainerView.isHidden = false
        trackUserEvent(.OPEN,
                       value: interactor?.selectedSprint?.remoteID,
                       stringValue: interactor?.selectedSprintTitle,
                       valueType: .CONTENT,
                       action: .PRESS)
        let cancelButtonItem = roundedBarButtonItem(title: R.string.localized.buttonTitleCancel(),
                                                     buttonWidth: .Cancel,
                                                     action: #selector(didPressDimissInfoView),
                                                     backgroundColor: .carbonDark,
                                                     borderColor: .accent40)
        let continueButtonItem = roundedBarButtonItem(title: R.string.localized.alertButtonTitleContinue(),
                                                     buttonWidth: .Continue,
                                                     action: #selector(didTapStartSprint),
                                                     backgroundColor: .carbonDark,
                                                     borderColor: .accent40)
        let navigationItem = BottomNavigationItem(leftBarButtonItems: [],
                                                  rightBarButtonItems: [continueButtonItem, cancelButtonItem],
                                                  backgroundColor: .clear)
        NotificationCenter.default.post(name: .updateBottomNavigation, object: navigationItem)
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
}

// MARK: - Bottom Navigation Items
extension DecisionTreeViewController {

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return leftNavigationItems
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        if isMindsetShifterLastQuestion {
            return [roundedBarButtonItem(title: R.string.localized.buttonTitleDone(),
                                         buttonWidth: .Done,
                                         action: #selector(didTapContinue))]
        }
        return interactor?.bottomNavigationRightBarItems(action: #selector(didTapContinue))
    }
}

// MARK: - Permission Calendar
extension DecisionTreeViewController {
    func checkCalendarPermissions() {
        let authStatus = EKEventStore.authorizationStatus(for: .event)
        switch authStatus {
        case .denied:
            presentPermissionView(openSettings: true)
        case .notDetermined:
            presentPermissionView(openSettings: false)
        default:
            loadNextQuestion(nextQuestion)
        }
    }

    func askCalendarPermission() {
        CalendarPermission().askPermission { [weak self] (granted) in
            if granted == true {
                qot_dal.CalendarService.main.importCalendarEvents()
                self?.hidePermissionView()
                self?.loadNextQuestion(self?.nextQuestion)
            } else {
                self?.hidePermissionView()
            }
        }
    }

    @objc func didTapSkipPermission() {
        hidePermissionView()
    }

    @objc func didTapAllowPermission() {
        askCalendarPermission()
    }

    @objc func didTapOpenSettings() {
        UIApplication.openAppSettings()
    }

    func presentPermissionView(openSettings: Bool) {
        view.addSubview(permissionView)
        permissionView.edges(to: view)
        let skipButtonItem = roundedBarButtonItem(title: R.string.localized.buttonTitleSkip().uppercased(),
                                                  buttonWidth: .Done,
                                                  action: #selector(didTapSkipPermission),
                                                  backgroundColor: .clear,
                                                  borderColor: .accent40)
        let allowButtonItem = roundedBarButtonItem(title: R.string.localized.buttonTitleAllow(),
                                                   buttonWidth: .Done,
                                                   action: #selector(didTapAllowPermission),
                                                   backgroundColor: .clear,
                                                   borderColor: .accent40)
        let settingsButtonItem = roundedBarButtonItem(title: R.string.localized.alertButtonTitleOpenSettings(),
                                                  buttonWidth: .Done * 2,
                                                  action: #selector(didTapOpenSettings),
                                                  backgroundColor: .clear,
                                                  borderColor: .accent40)
        var rightBarButtonItems = [allowButtonItem, skipButtonItem]
        if openSettings == true {
            rightBarButtonItems = [settingsButtonItem, skipButtonItem]
        }
        let navigationItem = BottomNavigationItem(leftBarButtonItems: [],
                                                  rightBarButtonItems: rightBarButtonItems,
                                                  backgroundColor: .clear)
        NotificationCenter.default.post(name: .updateBottomNavigation, object: navigationItem)
    }

    func hidePermissionView() {
        let leftBaruttonItems = [dismissNavigationItem()]
        DispatchQueue.main.async { [weak self] in
            self?.permissionView.removeFromSuperview()
            let navigationItem = BottomNavigationItem(leftBarButtonItems: leftBaruttonItems,
                                                      rightBarButtonItems: [],
                                                      backgroundColor: .clear)
            NotificationCenter.default.post(name: .updateBottomNavigation, object: navigationItem)
        }
    }
}
