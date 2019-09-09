//
//  DTSprintViewController.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTSprintViewController: UIViewController {

    // MARK: - Properties
    var interactor: DTSprintInteractorInterface?
    var router: DTSprintRouterInterface?
    private var viewModel: ViewModel?
    private weak var pageController: UIPageViewController?
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var navigationButtonContainer: UIView!
    @IBOutlet private weak var pageControllerContainer: UIView!

    // MARK: - Init
    init(configure: Configurator<DTSprintViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
}

// MARK: - Private
private extension DTSprintViewController {
    func setupPageViewController(_ backgroundColor: UIColor) {
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
        pageController.view.backgroundColor = backgroundColor
        addChildViewController(pageController)
        view.insertSubview(pageController.view, aboveSubview: pageControllerContainer)
        pageController.setViewControllers([UIViewController()], direction: .forward, animated: false, completion: nil)
        self.pageController = pageController
    }

    func setNavigationButton(_ viewModel: ViewModel) {
        navigationButtonContainer.removeSubViews()
        if let navigationButton = viewModel.navigationButton {
            navigationButtonContainer.addSubview(navigationButton)
            navigationButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        }
    }

    func showQuestion(viewModel: ViewModel, direction: UIPageViewController.NavigationDirection) {
        self.viewModel = viewModel
        previousButton.isHidden = viewModel.previousButtonIsHidden
        closeButton.isHidden = viewModel.dismissButtonIsHidden
        let controller = DTSprintQuestionnaireViewController(viewModel: viewModel)
        controller.delegate = self
        controller.interactor = interactor
        setNavigationButton(viewModel)
        pageController?.setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }

    func loadNextQuestion() {
        let selectedAnswer = viewModel?.answers.filter { $0.selected }.first
        let selectionModel = SelectionModel(selectedAnswer: selectedAnswer, userInput: nil)
        interactor?.loadNextQuestion(selection: selectionModel)
    }
}

// MARK: - Actions
private extension DTSprintViewController {
    @IBAction func didTapPrevious() {
        interactor?.loadPreviousQuestion()
    }

    @IBAction func didTapClose() {
        AppDelegate.current.launchHandler.dismissChatBotFlow()
    }

    @IBAction func didTapNext() {
        if viewModel?.question.key == DTSprintModel.QuestionKey.Last {
            didTapClose()
        } else {
                loadNextQuestion()
        }
    }

    @objc func didTapStartSprint() {
        interactor?.stopActiveSprintAndStartNewSprint()
    }

    @objc func didPressDimissInfoView() {
        trackUserEvent(.CLOSE,
                       stringValue: interactor?.getSelectedSprintTitle(),
                       valueType: .CONTENT,
                       action: .PRESS)
    }
}

// MARK: - DTSprintViewControllerInterface
extension DTSprintViewController: DTSprintViewControllerInterface {
    func setupView(_ backgroundColor: UIColor, _ dotsColor: UIColor) {
        view.backgroundColor = backgroundColor
        setupPageViewController(backgroundColor)
    }

    func showNextQuestion(_ viewModel: ViewModel) {
        showQuestion(viewModel: viewModel, direction: .forward)
    }

    func showPreviosQuestion(_ viewModel: ViewModel) {
        showQuestion(viewModel: viewModel, direction: .reverse)
    }

    func presentInfoView(icon: UIImage?, title: String?, text: String?) {
        trackUserEvent(.OPEN,
                       stringValue: interactor?.getSelectedSprintTitle(),
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
}

// MARK: - DTSprintQuestionnaireViewControllerDelegate
extension DTSprintViewController: DTSprintQuestionnaireViewControllerDelegate {
    func didTapBinarySelection(_ answer: ViewModel.Answer) {
        switch answer.keys.first {
        case DTSprintModel.AnswerKey.StartTomorrow:
            interactor?.startSprintTomorrow(selection: SelectionModel(selectedAnswer: answer, userInput: nil))
        case DTSprintModel.AnswerKey.AddToQueue:
            interactor?.addSprintToQueue(selection: SelectionModel(selectedAnswer: answer, userInput: nil))
        default:
            return
        }
    }

    func didSelectAnswer(_ answer: ViewModel.Answer) {
        viewModel?.setSelectedAnswer(answer)
        guard let viewModel = viewModel else { return }
        if viewModel.question.answerType == .singleSelection {
            loadNextQuestion()
        }
    }

    func didDeSelectAnswer(_ answer: ViewModel.Answer) {}
}
