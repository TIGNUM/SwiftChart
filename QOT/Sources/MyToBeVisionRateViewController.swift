//
//  MyToBeVisionRateViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyToBeVisionRateViewControllerProtocol: class {
    func doneAction()
}

final class MyToBeVisionRateViewController: UIViewController {

    @IBOutlet private weak var pageContainerView: UIView!
    @IBOutlet private weak var pageIndicatorView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var loaderView: UIView!
    @IBOutlet private weak var timerView: UIView!

    private var showCountDownPage = false
    private var isLastPage: Bool = false

    private var currentPageIndex: Int = 0
    private var nextPageTimer: Timer?
    private let pageIndicator = MyToBeVisionPageComponentView()
    private var pageController: UIPageViewController?
    private var tracks: [MyToBeVisionRateViewModel.Question] = []

    var delegate: MyToBeVisionRateViewControllerProtocol?
    var interactor: MyToBeVisionRateInteracorInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController?.view.frame = pageContainerView.frame
    }

    func questionnaireViewController(with question: MyToBeVisionRateViewModel.Question?) -> UIViewController? {
        guard let questionnaire = question else { return nil }
        return QuestionnaireViewController.viewController(with: questionnaire, delegate: self)
    }

    func indexOf(_ viewController: UIViewController?) -> Int {
        guard let vc = viewController as? QuestionnaireViewController else {
            return NSNotFound
        }
        let id = vc.questionID()
        guard let filteredIndices = tracks.indices.filter ({tracks[$0].remoteID == id}).first else { return 0 }
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
        if previousIndex < 0 {
            return nil
        }

        return questionnaireViewController(with: tracks[previousIndex])
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        if showCountDownPage {
            return generateBottomNavigationBarForTimerView()
        } else if isLastPage {
            return generateBottomNavigationBarForView()
        } else {
            return nil
        }
    }

    private func generateBottomNavigationBarForView() -> [UIBarButtonItem] {
        return [roundedBarButtonItem(title: R.string.localized.rateViewControllerDoneButton(), buttonWidth: 71, action: #selector(doneAction), backgroundColor: .carbon)]
    }

    private func generateBottomNavigationBarForTimerView() -> [UIBarButtonItem] {
        return [roundedBarButtonItem(title: R.string.localized.rateViewControllerSkipButton(), buttonWidth: 64, action: #selector(skipAction), backgroundColor: .carbon, borderColor: .accent)]
    }

    @objc func skipAction() {
        trackUserEvent(.CLOSE, valueType: "CountDownView", action: .TAP)
        shouldSkip()
    }

    @objc private func doneAction() {
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

        let nextIndex = currentIndex + 1
        if nextIndex >= tracks.count {
            return nil
        }
        return questionnaireViewController(with: tracks[nextIndex])
    }

    @IBAction func backAction() {
        guard let currentViewController = pageController?.viewControllers?.first else { return }
        let index = indexOf(currentViewController)
        guard index > 0 else { return }
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

extension MyToBeVisionRateViewController: MyToBeVisionCountDownViewControllerProtocol {
    func shouldSkip() {
        showCountDownPage = false
        refreshBottomNavigationItems()
        interactor?.hideTimerView {[weak self] in
            self?.interactor?.skipCountDownView()
        }
    }

    func shouldDismiss() {
        interactor?.dismiss()
    }
}

extension MyToBeVisionRateViewController: MyToBeVisionRateViewControllerInterface {

    func showCountDownView(_ view: UIView?) {
        guard let clountDownView = view else { return }
        showCountDownPage = true
        timerView.isHidden = false
        clountDownView.translatesAutoresizingMaskIntoConstraints = false
        timerView.addSubview(clountDownView)
        clountDownView.addConstraints(to: timerView)
    }

    func hideTimerView(completion: @escaping (() -> Void)) {
        UIView.animate(withDuration: Animation.duration_04,
                       animations: {
                        self.timerView.alpha = 0
        },
                       completion: { _ in
                        completion()
                        self.timerView.removeSubViews()
                        self.timerView.isHidden = true
        })
    }

    func showScreenLoader() {
        loaderView.isHidden = false
    }

    func hideScreenLoader() {
        loaderView.isHidden = true
    }

    func setupView(questions: [MyToBeVisionRateViewModel.Question]) {
        self.tracks = questions
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        pageIndicatorView?.addSubview(pageIndicator)
        pageIndicator.addConstraints(to: pageIndicatorView)
        pageIndicator.pageCount = questions.count
        view.backgroundColor = .carbon
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.delegate = self
        pageController.dataSource = self
        self.pageController = pageController
        self.addChildViewController(pageController)
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
        refreshBottomNavigationItems()
    }

    func isSelecting(answer: Int, for questionIdentifier: Int?, from viewController: UIViewController) {
        nextPageTimer?.invalidate()
        nextPageTimer = nil
    }

    func didSelect(answer: Int, for questionIdentifier: Int?, from viewController: UIViewController) {
        let index = indexOf(viewController)
        tracks[index].answerIndex = answer
        interactor?.addRating(for: questionIdentifier ?? 0, value: itemsOf(viewController) - answer)
        trackUserEvent(.SELECT, value: answer, valueType: "RateQuestion", action: .SWIPE)
        guard let nextViewController = next(from: viewController) else { return }
        nextPageTimer = Timer.scheduledTimer(withTimeInterval: Animation.duration_04, repeats: false) { timer in
        self.pageController?.setViewControllers([nextViewController],
                                                    direction: .forward,
                                                    animated: true,
                                                    completion: nil)
        }
    }
}
