//
//  DTViewController.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

class DTViewController: UIViewController, DTViewControllerInterface, DTQuestionnaireViewControllerDelegate, ScreenZLevelChatBot {

    // MARK: - Properties
    var viewModel: DTViewModel?
    var router: DTRouterInterface?
    var interactor: DTInteractorInterface?
    private weak var navigationButton: NavigationButton?
    private weak var pageController: UIPageViewController?
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var navigationButtonContainer: UIView!
    @IBOutlet weak var pageControllerContainer: UIView!
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.chatbot.apply(view)
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateBottomNavigation([], [])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController?.view.frame = pageControllerContainer.frame
    }

    // MARK: - Actions
    @IBAction func didTapPrevious() {
        interactor?.loadPreviousQuestion()
    }

    @IBAction func didTapClose() {
        router?.dismiss()
    }

    @IBAction func didTapNext() {
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

    func getEvent(answerType: AnswerType?) -> DTViewModel.Event? {
        return nil
    }

    func loadNextQuestion() {
        let selectedAnswers = viewModel?.selectedAnswers ?? []
        let filter = getAnswerFilter(selectedAnswers: selectedAnswers, questionKey: viewModel?.question.key)
        let trigger = getTrigger(selectedAnswer: selectedAnswers.first, questionKey: viewModel?.question.key)
        let event = getEvent(answerType: viewModel?.question.answerType)
        let selectionModel = DTSelectionModel(selectedAnswers: selectedAnswers,
                                              question: viewModel?.question,
                                              event: event,
                                              trigger: trigger,
                                              answerFilter: filter,
                                              userInput: nil)
        interactor?.loadNextQuestion(selection: selectionModel)
    }

    func showQuestion(viewModel: DTViewModel, direction: UIPageViewController.NavigationDirection) {
        updateView(viewModel: viewModel)
        let controller = DTQuestionnaireViewController(viewModel: viewModel)
        controller.delegate = self
        controller.interactor = interactor
        pageController?.setViewControllers([controller], direction: direction, animated: true, completion: nil)
//        handleAutomatedQuestion(viewModel: viewModel)
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
            navigationButton.setOnPressed(completion: { [weak self] in
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
    func setupView(_ backgroundColor: UIColor, _ dotsColor: UIColor) {
        setupPageViewController(backgroundColor)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }

    func updateView(viewModel: DTViewModel) {
        self.viewModel = viewModel
        previousButton.isHidden = viewModel.previousButtonIsHidden
        closeButton.isHidden = viewModel.dismissButtonIsHidden
    }

    private func setupPageViewController(_ backgroundColor: UIColor) {
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
        pageController.view.backgroundColor = backgroundColor
        addChildViewController(pageController)
        view.insertSubview(pageController.view, aboveSubview: pageControllerContainer)
        pageController.setViewControllers([UIViewController()], direction: .forward, animated: false, completion: nil)
        self.pageController = pageController
    }

    // MARK: - DTQuestionnaireViewControllerDelegate
    func didTapBinarySelection(_ answer: DTViewModel.Answer) {
        setAnswerNeedsSelection(answer)
        loadNextQuestion()
    }

    func didSelectAnswer(_ answer: DTViewModel.Answer) {
        viewModel?.setSelectedAnswer(answer)
        guard let viewModel = viewModel else { return }
        if viewModel.question.answerType == .singleSelection {
            loadNextQuestion()
        }
    }

    func didDeSelectAnswer(_ answer: DTViewModel.Answer) {
        viewModel?.setSelectedAnswer(answer)
    }

    func didSelectPreparationEvent(_ event: DTViewModel.Event?) {}

    /**
     An answer contains the decision about the next question to load or needed content.
     Some questions will be displayed without answers. If the an answer can not be
     selected by the user, the selection will happen here on `didTapNext()`.

     - Parameter answer: The answer to select if exist otherwise select first available.
     */
    func setAnswerNeedsSelection(_ answer: DTViewModel.Answer? = nil) {
        if var answer = answer {
            answer.setSelected(true)
            viewModel?.setSelectedAnswer(answer)
        } else if var answer = viewModel?.answers.first {
            answer.setSelected(true)
            viewModel?.setSelectedAnswer(answer)
        }
    }
}

extension DTViewController {        //TODO - this looks to be redundant now
    func handleAutomatedQuestion(viewModel: DTViewModel) {
        guard viewModel.showNextQuestionAutomated == true else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + Animation.duration_3) { [weak self] in
            self?.setAnswerNeedsSelection()
            self?.loadNextQuestion()
        }
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
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            constraintBottom.constant = keyboardSize.height
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()

            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            constraintBottom.constant = 0.0
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
