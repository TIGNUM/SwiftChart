//
//  DailyCheckinQuestionsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 16.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DailyCheckinQuestionsViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties

    @IBOutlet private weak var topNavigationView: UIView!
    @IBOutlet private weak var pageContainerView: UIView!
    @IBOutlet private weak var pageIndicatorView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    private var currentAnswer: Int?

    var isDoneButtonEnabled: Bool = false
    var interactor: DailyCheckinQuestionsInteractorInterface?
    private var pageController: UIPageViewController?
    private var nextPageTimer: Timer?
    private let pageIndicator = MyToBeVisionPageComponentView()

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = .sand
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController?.view.frame = pageContainerView.frame
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return [dismissNavigationItem()]
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        guard isDoneButtonEnabled else {
            return []
        }
        var backgroundColor = UIColor.carbon.withAlphaComponent(0.5)
            backgroundColor = .carbon
        return [roundedBarButtonItem(title: R.string.localized.questionnaireViewControllerDoneButton(),
                                     buttonWidth: .Done,
                                     action: #selector(doneAction),
                                     backgroundColor: backgroundColor,
                                     borderColor: .clear)]
    }
}

// MARK: - Actions

private extension DailyCheckinQuestionsViewController {

    func questionnaireViewController(with question: RatingQuestionViewModel.Question?) -> UIViewController? {
        guard let questionnaire = question else { return nil }
        return QuestionnaireViewController.viewController(with: questionnaire, delegate: self, controllerType: .dailyCheckin)
    }

    func indexOf(_ viewController: UIViewController?) -> Int {
        guard let interactor = self.interactor,
            let vc = viewController as? QuestionnaireViewController else {
            return NSNotFound
        }
        let id = vc.questionID()
        guard let filteredIndices = interactor.questions.indices.filter ({interactor.questions[$0].remoteID == id}).first else { return 0 }
        return filteredIndices
    }

    func itemsOf(_ viewController: UIViewController?) -> Int {
        guard let vc = viewController as? QuestionnaireViewController else {
            return NSNotFound
        }
        return vc.itemsCount()
    }

    func previous(from viewController: UIViewController) -> UIViewController? {
        guard let interactor = self.interactor else { return nil }
        var currentIndex = indexOf(viewController)
        if currentIndex == NSNotFound {
            currentIndex = interactor.questions.count
        }

        let previousIndex = currentIndex - 1
        trackUserEvent(.OPEN, value: previousIndex, valueType: "DailyCheckin.PresentedQuestion", action: .SWIPE)

        if previousIndex < 0 {
            return nil
        }
        return questionnaireViewController(with: interactor.questions[previousIndex])
    }

    func next(from viewController: UIViewController) -> UIViewController? {
        guard let interactor = self.interactor else { return nil }
        let currentIndex = indexOf(viewController)
        if currentIndex == NSNotFound {
            return nil
        }
        if interactor.questions[currentIndex].selectedAnswerIndex == nil {
            return nil
        }
        let nextIndex = currentIndex + 1
        trackUserEvent(.OPEN, value: nextIndex, valueType: "DailyCheckin.PresentedQuestion", action: .SWIPE)
        if nextIndex >= interactor.questions.count {
            return nil
        }
        return questionnaireViewController(with: interactor.questions[nextIndex])
    }

    @IBAction func backAction() {
        let currentViewController = pageController?.viewControllers?.first
        let index = indexOf(currentViewController)
        guard index > 0 && index != NSNotFound else { return }
        trackUserEvent(.OPEN, value: index, valueType: "DailyCheckin.PresentedQuestion", action: .TAP)
        nextPageTimer?.invalidate()
        nextPageTimer = nil
        let question = interactor?.questions[index - 1]
        guard let viewController = questionnaireViewController(with: question) else { return }
        pageController?.setViewControllers([viewController], direction: .reverse, animated: false, completion: nil)
    }
}

// MARK: - DailyCheckinQuestionsViewControllerInterface

extension DailyCheckinQuestionsViewController: DailyCheckinQuestionsViewControllerInterface {
    func setupView() {
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        pageIndicatorView?.addSubview(pageIndicator)
        pageIndicator.addConstraints(to: pageIndicatorView)
        pageIndicator.pageColor = .carbon
        pageIndicator.pageCount = interactor?.questions.count ?? 0
        view.backgroundColor = .sand
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.delegate = self
        pageController.dataSource = self
        self.pageController = pageController
        self.addChildViewController(pageController)
        view.insertSubview(pageController.view, belowSubview: pageContainerView)
        pageController.view.clipsToBounds = false
        if let viewController = questionnaireViewController(with: interactor?.questions.first) {
            pageController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
    }

    @objc override public func didTapDismissButton() {
        trackUserEvent(.CLOSE, action: .TAP)
        interactor?.dismiss()
    }

    @objc private func doneAction() {
        NotificationCenter.default.post(name: .didFinishDailyCheckin, object: nil)
        guard isDoneButtonEnabled else { return }
        trackUserEvent(.CONFIRM, valueType: "DailyCheckin.SaveAnswers", action: .TAP)
        interactor?.saveAnswers()
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension DailyCheckinQuestionsViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        nextPageTimer?.invalidate()
        nextPageTimer = nil
        return previous(from: viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        nextPageTimer?.invalidate()
        nextPageTimer = nil
        return next(from: viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        nextPageTimer?.invalidate()
        nextPageTimer = nil
    }
}

extension DailyCheckinQuestionsViewController: QuestionnaireAnswer {
    func isPresented(for questionIdentifier: Int?, from viewController: UIViewController) {
        let index = indexOf(viewController)
        if index == NSNotFound { return }
        pageIndicator.currentPageIndex = index
        backButton.isHidden = index < 1
        isDoneButtonEnabled = interactor?.questions.count ?? 0 == interactor?.answeredQuestionCount
        refreshBottomNavigationItems()
    }

    func isSelecting(answer: Int, for questionIdentifier: Int?, from viewController: UIViewController) {
        nextPageTimer?.invalidate()
        nextPageTimer = nil
    }

    func didSelect(answer: Int, for questionIdentifier: Int?, from viewController: UIViewController) {
        let index = indexOf(viewController)
        if index == NSNotFound { return }
        interactor?.questions[index].selectedAnswerIndex = answer
        trackUserEvent(.SELECT, value: answer, valueType: "DailyCheckin.RateQuestion", action: .SWIPE)
        isDoneButtonEnabled = interactor?.questions.count ?? 0 == interactor?.answeredQuestionCount
        refreshBottomNavigationItems()
        guard let nextViewController = next(from: viewController) else {
            return
        }
        nextPageTimer = Timer.scheduledTimer(withTimeInterval: Animation.duration_04, repeats: false) { timer in
            self.pageController?.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}
