//
//  DTViewController.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

class DTViewController: UIViewController, DTViewControllerInterface, DTQuestionnaireViewControllerDelegate {

    // MARK: - Properties
    var interactor: DTInteractor?
    var router: DTRouterInterface?
    var viewModel: DTViewModel?
    var selectedAnswers: [DTViewModel.Answer] = []
    weak var pageController: UIPageViewController?
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

    func getAnswerFilter(selectedAnswer: DTViewModel.Answer?, questionKey: String?) -> String? {
        return nil
    }

    func getTrigger(selectedAnswer: DTViewModel.Answer?, questionKey: String?) -> String? {
        return nil
    }

    func getUsersTBV() -> QDMToBeVision? {
        return nil
    }

    // MARK: - Question Handling
    func loadNextQuestion() {
        let newSelectedAnswers = viewModel?.answers.filter { $0.selected }
        let selectedAnswer = newSelectedAnswers?.first
        let filter = getAnswerFilter(selectedAnswer: selectedAnswer, questionKey: viewModel?.question.key)
        let trigger = getTrigger(selectedAnswer: selectedAnswer, questionKey: viewModel?.question.key)
        let tbv = getUsersTBV()
        let selectionModel = DTSelectionModel(selectedAnswer: selectedAnswer,
                                              trigger: trigger,
                                              answerFilter: filter,
                                              userInput: nil,
                                              tbv: tbv)
        selectedAnswers.append(contentsOf: newSelectedAnswers ?? [])
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

    func presentInfoView(icon: UIImage?, title: String?, text: String?) {}

    // MARK: Configuration
    func setupView(_ backgroundColor: UIColor, _ dotsColor: UIColor) {
        view.backgroundColor = backgroundColor
        setupPageViewController(backgroundColor)
    }

    func setNavigationButton(_ viewModel: DTViewModel) {
        navigationButtonContainer.removeSubViews()
        if let navigationButton = interactor?.navigationButton(viewModel) {
            navigationButtonContainer.addSubview(navigationButton)
            navigationButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        }
    }

    func updateView(viewModel: DTViewModel) {
        self.viewModel = viewModel
        previousButton.isHidden = viewModel.previousButtonIsHidden
        closeButton.isHidden = viewModel.dismissButtonIsHidden
        setNavigationButton(viewModel)
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
    func didTapBinarySelection(_ answer: DTViewModel.Answer) {}

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

    func refreshNavigationButton() {
        guard let viewModel = viewModel else { return }
        setNavigationButton(viewModel)
    }
}
