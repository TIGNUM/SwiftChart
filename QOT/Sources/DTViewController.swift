//
//  DTViewController.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

class DTViewController: BaseViewController,
                        DTViewControllerInterface,
                        DTQuestionnaireViewControllerDelegate,
                        ScreenZLevelChatBot {

    // MARK: - Properties
    var viewModel: DTViewModel?
    var router: DTRouterInterface?
    var interactor: DTInteractorInterface!
    var triggeredByLaunchHandler = false
    private weak var navigationButton: NavigationButton?
    private weak var pageController: UIPageViewController?
    @IBOutlet weak var previousButton: AnimatedButton!
    @IBOutlet weak var closeButton: AnimatedButton!
    @IBOutlet weak var navigationButtonContainer: UIView!
    @IBOutlet weak var pageControllerContainer: UIView!
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    @IBOutlet weak var viewNavBottom: UIView!
    @IBOutlet weak var navBottomGradientImageView: UIImageView!
    @IBOutlet weak var viewNavTop: UIView!

    private var canGetBackToPreviousQuestions = false

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        let isDark = interactor.isDark

        let theme: ThemeView = isDark ? .chatbotDark : .chatbot
        theme.apply(view)

        let image = R.image.ic_close()
        closeButton.setImage(image, for: .normal)
        ThemeTint.black.apply(closeButton.imageView ?? UIView.init())
        closeButton.layer.borderWidth = 1
        closeButton.corner(radius: 20)
        closeButton.layer.borderColor = UIColor.black.cgColor
        let imageUp = R.image.ic_arrow_up()
        previousButton.setImage(imageUp, for: .normal)
        isDark ? ThemeTint.white.apply(previousButton.imageView ?? UIView.init()) : ThemeTint.black.apply(previousButton.imageView ?? UIView.init())

        if isDark {
            ThemeBorder.white.apply(previousButton)
            navBottomGradientImageView.image = R.image.gradient_dark()
        }

        navigationController?.setNeedsStatusBarAppearanceUpdate()
        setupPageViewController(view.backgroundColor)
        interactor.viewDidLoad()

        setupSwipeGestureRecognizer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
        updateBottomNavigation([], [])

        // Handling dismissing process when DecisionTree is triggered by Launch handler
        if !animated && triggeredByLaunchHandler == true,
            let mainNavigationController = baseRootViewController?.navigationController,
            self.navigationController?.presentingViewController == mainNavigationController {
            router?.dismissChatBotFlow()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController?.view.frame = pageControllerContainer.frame
    }

    // MARK: - Actions

    @IBAction func didTapPrevious() {
        constraintBottom.constant = .zero
        self.view.layoutIfNeeded()
        trackQuestionInteraction(.PREVIOUS)
        if interactor.loadPreviousQuestion(selectedIds: interactor.getSelectedIds()) == false {
            router?.dismiss()
        }
    }

    @IBAction func didTapClose() {
        router?.dismiss()
        trackQuestionInteraction()
    }

    @IBAction func didTapNext() {
        constraintToZero(0.3)
        setAnswerNeedsSelection()
        loadNextQuestion()
    }

    // MARK: - Question Handling
    func getAnswerFilter(selectedAnswers: [DTViewModel.Answer], questionKey: String?) -> String? {
        return nil
    }

    func getTrigger(selectedAnswer: DTViewModel.Answer?, questionKey: String?) -> String? {
        return nil
    }

    func loadNextQuestion(answerFilter: String? = nil) {
        guard let viewModel = viewModel else { return }
        let selectedAnswers = viewModel.selectedAnswers
        let filter = answerFilter != nil ? answerFilter : getAnswerFilter(selectedAnswers: selectedAnswers,
                                                                          questionKey: viewModel.question.key)
        let trigger = getTrigger(selectedAnswer: selectedAnswers.first, questionKey: viewModel.question.key)
        let selectionModel = DTSelectionModel(selectedAnswers: selectedAnswers,
                                              question: viewModel.question,
                                              trigger: trigger,
                                              answerFilter: filter,
                                              userInput: nil)
        interactor.loadNextQuestion(selection: selectionModel)
    }

    func showQuestion(viewModel: DTViewModel,
                      direction: UIPageViewController.NavigationDirection,
                      animated: Bool = true) {
        updateView(viewModel: viewModel)
        let controller = DTQuestionnaireViewController(viewModel: viewModel)
        controller.delegate = self
        controller.interactor = interactor
        pageController?.setViewControllers([controller], direction: direction, animated: animated, completion: nil)
    }

    // MARK: - DTViewControllerInterface
    func showNextQuestion(_ viewModel: DTViewModel) {
        showQuestion(viewModel: viewModel, direction: .forward)
    }

    func showPreviosQuestion(_ viewModel: DTViewModel) {
        showQuestion(viewModel: viewModel, direction: .reverse)
    }

    func setNavigationButton(_ button: NavigationButton?) {
        navigationButtonContainer.removeSubViews()
        if let navigationButton = button {
            self.navigationButton = navigationButton
            navigationButton.translatesAutoresizingMaskIntoConstraints = false
            navigationButtonContainer.addSubview(navigationButton)
            navigationButton.topAnchor.constraint(equalTo: navigationButtonContainer.topAnchor).isActive = true
            navigationButton.bottomAnchor.constraint(equalTo: navigationButtonContainer.bottomAnchor).isActive = true
            navigationButton.rightAnchor.constraint(equalTo: navigationButtonContainer.rightAnchor).isActive = true
            navigationButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
            navigationButton.setOnPressed(completion: { [weak self] () in
                self?.didTapNext()
            })
        }
    }

    func showNavigationButtonAfterAnimation() {
        navigationButton?.isHidden = false
    }

    func hideNavigationButtonForAnimation() {
        navigationButton?.isHidden = true
    }

    func presentInfoView(icon: UIImage?, title: String?, text: String?) {}

    // MARK: Configuration
    private func addObservers() {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.keyboardWillShow(notification)
        }

        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.keyboardWillHide(notification)
        }
    }

    func updateView(viewModel: DTViewModel) {
        self.viewModel = viewModel
        previousButton.isHidden = viewModel.previousButtonIsHidden
        closeButton.isHidden = viewModel.dismissButtonIsHidden
        setSelectedAnswersIfNeeded(viewModel: viewModel)
    }

    private func setSelectedAnswersIfNeeded(viewModel: DTViewModel) {
        let selectedAnswers = viewModel.answers.filter { $0.selected == true }
        selectedAnswers.forEach { (answer) in
            viewModel.setSelectedAnswer(answer)
        }
    }

    private func setupPageViewController(_ backgroundColor: UIColor?) {
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
        NewThemeView.light.apply(pageController.view)
        if let scrollview = pageController.view as? UIScrollView {
            scrollview.contentInsetAdjustmentBehavior = .automatic
        }
        addChild(pageController)
        view.insertSubview(pageController.view, aboveSubview: pageControllerContainer)
        self.pageController = pageController
    }

    // MARK: - DTQuestionnaireViewControllerDelegate
    func didTapBinarySelection(_ answer: DTViewModel.Answer) {
        setAnswerNeedsSelection(answer)
        loadNextQuestion()
    }

    func didSelectAnswer(_ answer: DTViewModel.Answer) {
        setSelectedAnswer(answer)
        guard let viewModel = viewModel else { return }
        if viewModel.question.answerType == .singleSelection {
            loadNextQuestion()
        }
    }

    func didDeSelectAnswer(_ answer: DTViewModel.Answer) {
        setSelectedAnswer(answer)
    }

    func didSwitchSingleSelectedAnswer(_ answer: DTViewModel.Answer) {
        let selectedAnswer = viewModel?.selectedAnswers.filter { $0.selected }.first
        NotificationCenter.default.post(name: .didSwitchSingleSelection, object: selectedAnswer?.remoteId ?? .zero)
        viewModel?.resetSelectedAnswers()
    }

    func didSelectExistingPreparation(_ qdmPreparation: QDMUserPreparation?) {
        trackUserEvent(.SELECT,
                       value: qdmPreparation?.remoteID,
                       stringValue: qdmPreparation?.name,
                       valueType: .USER_PREPARATION,
                       action: .TAP)
    }

    func setSelectedAnswer(_ answer: DTViewModel.Answer) {
        viewModel?.setSelectedAnswer(answer)
        let name: QDMUserEventTracking.Name = answer.selected == true ? .SELECT : .DESELECT
        trackAnswerSelection(answer, name)
    }

    /**
     An answer contains the decision about the next question to load or needed  .
     Some questions will be displayed without answers. If the an answer can not be
     selected by the user, the selection will happen here on `didTapNext()`.

     - Parameter answer: The answer to select if exist otherwise select first available.
     */
    func setAnswerNeedsSelection(_ answer: DTViewModel.Answer? = nil) {
        if var answer = answer {
            setAnswerSelected(&answer)
        } else if var answer = viewModel?.answers.first {
            setAnswerSelected(&answer)
        }
    }

    private func setAnswerSelected(_ answer: inout DTViewModel.Answer) {
        answer.setSelected(true)
        setSelectedAnswer(answer)
        trackAnswerSelection(answer, .ANSWER_DECISION)
    }

    func setAnswerNeedsSelectionIfNoOtherAnswersAreSelectedAlready() {
        if viewModel?.answers.filter({ $0.selected }).isEmpty ?? true {
            setAnswerNeedsSelection()
        } else {
            if let answer = self.viewModel?.selectedAnswers.first,
                let buttonTitle = navigationButton?.getCurrentTitle() {
                self.trackAnswerSelection(answer, buttonTitle, .ANSWER_DECISION)
            }
        }
    }
}

// MARK: - User Event Tracking
extension DTViewController {
    func trackAnswerSelection(_ answer: DTViewModel.Answer,
                              _ name: QDMUserEventTracking.Name = .SELECT,
                              _ valueType: QDMUserEventTracking.ValueType = .USER_ANSWER) {
        trackUserEvent(name,
                       value: answer.remoteId,
                       stringValue: answer.title,
                       valueType: valueType,
                       action: .TAP)
    }

    func trackQuestionInteraction(_ name: QDMUserEventTracking.Name = .CLOSE) {
        trackUserEvent(name,
                       value: viewModel?.question.remoteId,
                       stringValue: viewModel?.question.title,
                       valueType: .QUESTION,
                       action: .TAP)
    }
}

// MARK: - Bottom Navigation
extension DTViewController {
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}

//Handle keyboard notifications
extension DTViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            constraintBottom.constant = keyboardSize.height
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            constraintToZero(duration)
        }
    }

    private func constraintToZero(_ duration: Double) {
        if constraintBottom.constant == .zero { return }
        constraintBottom.constant = .zero
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension DTViewController {
    func setupSwipeGestureRecognizer() {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDown(_:)))
        swipeGestureRecognizer.direction = .down
        swipeGestureRecognizer.numberOfTouchesRequired = 1
        swipeGestureRecognizer.delegate = self
        view.addGestureRecognizer(swipeGestureRecognizer)
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let viewController = pageController?.viewControllers?.first as? DTQuestionnaireViewController else {
            return false
        }
        let offset = viewController.contentOffset()
        return previousButton.isHidden == false && offset.y == .zero
    }

    @objc func didSwipeDown(_ recognizer: UIGestureRecognizer) {
        didTapPrevious()
    }
}
