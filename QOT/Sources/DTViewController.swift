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
    weak var interactor: DTInteractor?
    private weak var navigationButton: NavigationButton?
    private weak var pageController: UIPageViewController?
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var navigationButtonContainer: UIView!
    @IBOutlet weak var pageControllerContainer: UIView!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        AppDelegate.current.launchHandler.dismissChatBotFlow()
    }

    @objc func didTapNext() {

    }

    // MARK: - Question Handling
    func getAnswerFilter(selectedAnswers: [DTViewModel.Answer], questionKey: String?) -> String? {
        return nil
    }

    func getTrigger(selectedAnswer: DTViewModel.Answer?, questionKey: String?) -> String? {
        return nil
    }

    func loadNextQuestion() {
        let selectedAnswers = viewModel?.answers.filter { $0.selected } ?? []
        let filter = getAnswerFilter(selectedAnswers: selectedAnswers, questionKey: viewModel?.question.key)
        let trigger = getTrigger(selectedAnswer: selectedAnswers.first, questionKey: viewModel?.question.key)
        let selectionModel = DTSelectionModel(selectedAnswers: selectedAnswers,
                                              question: viewModel?.question,
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
            navigationButtonContainer.addSubview(navigationButton)
            navigationButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
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
        view.backgroundColor = backgroundColor
        setupPageViewController(backgroundColor)
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

// MARK: - Bottom Navigation
extension DTViewController {
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}
