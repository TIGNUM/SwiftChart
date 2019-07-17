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
    private var pageController: UIPageViewController?
    private var continueButton = DecisionTreeButton(type: .custom)
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var pageControllerContainer: UIView!
    @IBOutlet private weak var dotsLoadingView: DotsLoadingView!
    @IBOutlet private weak var infoView: InfoHelperView!
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
        let attributedTitle = NSAttributedString(string: "",
                                                 letterSpacing: 0.2,
                                                 font: .sfProtextSemibold(ofSize: 14),
                                                 textColor: .carbon30,
                                                 alignment: .center)
        continueButton.configure(with: "",
                                 attributedTitle: attributedTitle,
                                 selectedBackgroundColor: .carbonDark,
                                 defaultBackgroundColor: .carbon05,
                                 borderColor: .clear,
                                 titleColor: .accent)
        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        updateBottomNavigation(rightItems: [continueButton.toBarButtonItem()])
    }

    func setupTypingAnimation() {
        dotsLoadingView.configure(dotsColor: .carbonDark)
        dotsLoadingView.startAnimation()
    }
}

// MARK: - Actions
private extension DecisionTreeViewController {
    @IBAction func didTapPrevious(_ sender: UIButton) {
        trackUserEvent(.PREVIOUS, action: .TAP)
        moveBackward()
        interactor?.updateMultiSelectionCounter()
    }

    @objc func didTapContinue() {
        interactor?.didTapContinue()
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
        let deadline = DispatchTime.now() + (animated ? Animation.duration_1_5 : 0)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [unowned self] in
            if let dotsLoadingView = self.dotsLoadingView {
                dotsLoadingView.stopAnimation()
            }
            let controller = self.questionnaireController(for: question,
                                                          extraAnswer: extraAnswer,
                                                          filter: filter,
                                                          selectedAnswers: selectedAnswers)
            self.pageController?.setViewControllers([controller],
                                                    direction: direction,
                                                    animated: true,
                                                    completion: nil)
        }
    }

    func syncButtons(previousButtonIsHidden: Bool, continueButtonIsHidden: Bool, backgroundColor: UIColor) {
        previousButton.isHidden = previousButtonIsHidden
        continueButton.isHidden = continueButtonIsHidden
        continueButton.isUserInteractionEnabled = !continueButtonIsHidden
        continueButton.backgroundColor = backgroundColor
        updateBottomNavigation(rightItems: [continueButton.toBarButtonItem()])
    }

    func updateBottomButtonTitle(counter: Int, maxSelections: Int, defaultTitle: String?, confirmTitle: String?) {
        continueButton.update(with: counter,
                              defaultTitle: defaultTitle ?? "",
                              confirmationTitle: confirmTitle ?? "",
                              maxSelections: maxSelections)
        updateBottomNavigation(rightItems: [continueButton.toBarButtonItem()])
    }

    func toBeVisionDidChange() {
        delegate?.toBeVisionDidChange()
    }

    @objc func animateNavigationButton() {
        continueButton.pulsate()
    }
}

// MARK: - Private

private extension DecisionTreeViewController {
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
                                                                     questionTitleUpdate: "recoveryFatigueType?.replacement")
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

    func updateBottomNavigation(rightItems: [UIBarButtonItem]) {
        let navigationItem = BottomNavigationItem(leftBarButtonItems: [dismissNavigationItem()],
                                                  rightBarButtonItems: rightItems,
                                                  backgroundColor: .clear)
        NotificationCenter.default.post(name: .updateBottomNavigation, object: navigationItem)
    }
}

// MARK: - DecisionTreeQuestionnaireDelegate
extension DecisionTreeViewController: DecisionTreeQuestionnaireDelegate {
    @objc func didPressDimiss() {
        dismiss()
    }

    func didPressContinue() {
        didTapContinue()
    }

    func didUpdatePrepareBenefits(_ benefits: String?) {
        trackUserEvent(.ANSWER, stringValue: benefits, valueType: .USER_INPUT, action: .KEYBOARD)
        interactor?.prepareBenefits = benefits
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

    func textCellDidAppear(targetID: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Animation.duration_3) {
            NotificationCenter.default.post(name: .typingAnimationStart, object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + Animation.duration_3) {
                self.interactor?.loadNextQuestion(targetId: targetID, animated: true)
            }
        }
    }

    func didSelectCalendarEvent(_ event: QDMUserCalendarEvent, selectedAnswer: QDMAnswer) {
        interactor?.setUserCalendarEvent(event: event)
        trackUserEvent(.SELECT, stringValue: event.qotId, valueType: .CALENDAR_EVENT, action: .TAP)
        interactor?.loadNextQuestion(from: selectedAnswer)
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
        let cancelButtonItem = roundedDarkButtonItem(title: R.string.localized.buttonTitleCancel(),
                                                     buttonWidth: .cancelButtonWidth,
                                                     backgroundColor: .clear,
                                                     borderColor: .accent40,
                                                     action: #selector(didPressDimiss))
        let continueButtonItem = roundedDarkButtonItem(title: R.string.localized.alertButtonTitleContinue(),
                                                     buttonWidth: .continueButtonWidth,
                                                     borderColor: .accent40,
                                                     action: #selector(didTapStartSprint))
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
    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return interactor?.bottomNavigationRightBarItems(action: #selector(didTapContinue))
    }
}
