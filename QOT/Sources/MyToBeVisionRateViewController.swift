//
//  MyToBeVisionRateViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol MyToBeVisionRateViewControllerProtocol: class {
    func doneAction()
}

final class MyToBeVisionRateViewController: BaseViewController, ScreenZLevel3 {

    @IBOutlet private weak var pageContainerView: UIView!
    @IBOutlet private weak var pageIndicatorView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var loaderView: UIView!
    @IBOutlet private weak var timerView: UIView!

    private var isLastPage: Bool = false
    private var currentPageIndex: Int = 0
    private var nextPageTimer: Timer?
    private let pageIndicator = MyToBeVisionPageComponentView()
    private var pageController: UIPageViewController?

    private var tracks: [RatingQuestionViewModel.Question] = []

    weak var delegate: MyToBeVisionRateViewControllerProtocol?
    var interactor: MyToBeVisionRateInteracorInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .carbon
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController?.view.frame = pageContainerView.frame
    }

    func questionnaireViewController(with question: RatingQuestionViewModel.Question?) -> UIViewController? {
        guard let questionnaire = question else { return nil }
        return QuestionnaireViewController.viewController(with: questionnaire, delegate: self)
    }

    func indexOf(_ viewController: UIViewController?) -> Int {
        guard let vc = viewController as? QuestionnaireViewController else {
            return NSNotFound
        }
        let id = vc.questionID()
        guard let filteredIndices = tracks.indices.filter({tracks[$0].remoteID == id}).first else { return 0 }
        return filteredIndices
    }

    func itemsOf(_ viewController: UIViewController?) -> Int {
        guard let vc = viewController as? QuestionnaireViewController else {
            return NSNotFound
        }
        return vc.itemsCount()
    }

    func previous(from viewController: UIViewController) -> UIViewController? {
        var currentIndex = indexOf(viewController)
        if currentIndex == NSNotFound {
            currentIndex = tracks.count
        }

        let previousIndex = currentIndex - 1
        trackUserEvent(.OPEN, value: previousIndex, valueType: "MyToBeVision.PresentedQuestion", action: .SWIPE)
        if previousIndex < 0 {
            return nil
        }

        return questionnaireViewController(with: tracks[previousIndex])
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        if isLastPage {
            return nil
        } else {
            return super.bottomNavigationLeftBarItems()
        }
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        if isLastPage {
            return generateBottomNavigationBarForView()
        } else {
            return nil
        }
    }

    private func generateBottomNavigationBarForView() -> [UIBarButtonItem] {
        return [roundedBarButtonItem(title: AppTextService.get(.my_qot_my_tbv_tbv_tracker_result_section_footer_button_done),
                                     buttonWidth: .Done,
                                     action: #selector(doneAction),
                                     backgroundColor: .carbon,
                                     borderColor: .accent40)]
    }

    @objc private func doneAction() {
        trackUserEvent(.CONFIRM, valueType: "MyToBeVision.SaveAnswers", action: .TAP)
        interactor?.saveQuestions()
        dismiss(animated: true) {[weak self] in
            self?.delegate?.doneAction()
        }
    }

    func next(from viewController: UIViewController) -> UIViewController? {
        let currentIndex = indexOf(viewController)
        if currentIndex == NSNotFound {
            return nil
        }
        if tracks[currentIndex].selectedAnswerIndex == nil {
            return nil
        }
        let nextIndex = currentIndex + 1
        trackUserEvent(.OPEN, value: nextIndex, valueType: "MyToBeVision.PresentedQuestion", action: .SWIPE)
        if nextIndex >= tracks.count {
            return nil
        }
        return questionnaireViewController(with: tracks[nextIndex])
    }

    @IBAction func backAction() {
        guard let currentViewController = pageController?.viewControllers?.first else { return }
        let index = indexOf(currentViewController)
        guard index > 0 else { return }
        trackUserEvent(.OPEN, value: index, valueType: "MyToBeVision.PresentedQuestion", action: .TAP)
        nextPageTimer?.invalidate()
        nextPageTimer = nil
        let question = tracks[index - 1]
        guard let viewController = questionnaireViewController(with: question) else { return }
        pageController?.setViewControllers([viewController], direction: .reverse, animated: false, completion: nil)
    }

    @IBAction func dismissAction() {
        interactor?.dismiss()
    }
}

extension MyToBeVisionRateViewController: MyToBeVisionRateViewControllerInterface {

    func showScreenLoader() {
        loaderView.isHidden = false
    }

    func hideScreenLoader() {
        loaderView.isHidden = true
    }

    func setupView(questions: [RatingQuestionViewModel.Question]) {
        ThemeView.level3.apply(view)

        self.tracks = questions
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        pageIndicatorView?.addSubview(pageIndicator)
        pageIndicator.addConstraints(to: pageIndicatorView)
        pageIndicator.pageColor = .sand
        pageIndicator.pageCount = questions.count
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.delegate = self
        pageController.dataSource = self
        self.pageController = pageController
        self.addChild(pageController)
        view.insertSubview(pageController.view, belowSubview: pageContainerView)
        pageController.view.clipsToBounds = false
        if let viewController = questionnaireViewController(with: self.tracks.first) {
            pageController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension MyToBeVisionRateViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let previous = previous(from: viewController) else { return nil }
        nextPageTimer?.invalidate()
        nextPageTimer = nil
        return previous
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let next = next(from: viewController) else { return nil }
        nextPageTimer?.invalidate()
        nextPageTimer = nil
        return next
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        nextPageTimer?.invalidate()
        nextPageTimer = nil
    }
}

extension MyToBeVisionRateViewController: QuestionnaireAnswer {

    func isPresented(for questionIdentifier: Int?, from viewController: UIViewController) {
        let index = indexOf(viewController)
        pageIndicator.currentPageIndex = index
        backButton.isHidden = index < 1
        isLastPage = index == (tracks.count - 1)

        interactor?.addRating(for: questionIdentifier ?? 0,
                              value: itemsOf(viewController) - (tracks[index].selectedAnswerIndex ?? 5))
        refreshBottomNavigationItems()
    }

    func isSelecting(answer: Int, for questionIdentifier: Int?, from viewController: UIViewController) {
        nextPageTimer?.invalidate()
        nextPageTimer = nil
    }

    func didSelect(answer: Int, for questionIdentifier: Int?, from viewController: UIViewController) {
        let index = indexOf(viewController)
        tracks[index].selectedAnswerIndex = answer
        interactor?.addRating(for: questionIdentifier ?? 0, value: itemsOf(viewController) - answer)
        trackUserEvent(.SELECT, value: answer, valueType: "MyToBeVision.RateQuestion", action: .SWIPE)
        guard let nextViewController = next(from: viewController) else {
            return
        }
        nextPageTimer = Timer.scheduledTimer(withTimeInterval: Animation.duration_04, repeats: false) { timer in
            self.pageController?.setViewControllers([nextViewController],
                                                    direction: .forward,
                                                    animated: true,
                                                    completion: nil)
        }
    }
}
