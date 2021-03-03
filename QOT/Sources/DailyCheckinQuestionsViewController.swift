//
//  DailyCheckinQuestionsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 16.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DailyCheckinQuestionsViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    @IBOutlet private weak var topNavigationView: UIView!
    @IBOutlet private weak var pageContainerView: UIView!
    @IBOutlet private weak var pageIndicatorLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!

    var isDoneButtonEnabled: Bool = false
    var interactor: DailyCheckinQuestionsInteractorInterface?
    private var pageController: UIPageViewController?
    private var loadingDots: DotsLoadingView?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.viewWillAppear()
        setStatusBar(colorMode: .dark)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.viewDidAppear()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController?.view.frame = pageContainerView.frame
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return [dismissNavigationItem()]
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        var backgroundColor = UIColor.black
        var currentIndex = NSNotFound
        if let vc = pageController?.viewControllers?.first as? QuestionnaireViewController {
            currentIndex = indexOf(vc)
        }

        backgroundColor = .black
        if isDoneButtonEnabled {
            return [roundedBarButtonItem(title: AppTextService.get(.daily_brief_daily_check_in_questionnaire_section_footer_button_done),
            buttonWidth: .Done,
            action: #selector(doneAction),
            textColor: .white,
            backgroundColor: backgroundColor,
            borderColor: .white)]
        } else if currentIndex != NSNotFound {
            return [roundedBarButtonItem(title: AppTextService.get(.daily_brief_daily_check_in_questionnaire_section_footer_button_next),
            buttonWidth: .Done,
            action: #selector(nextAction),
            textColor: .white,
            backgroundColor: backgroundColor,
            borderColor: .white)]
        }
        return []
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
        guard let filteredIndices = interactor.questions.indices.filter({interactor.questions[$0].remoteID == id}).first else { return .zero }
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

        if previousIndex < .zero {
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
        guard index > .zero && index != NSNotFound else { return }
        trackUserEvent(.OPEN, value: index, valueType: "DailyCheckin.PresentedQuestion", action: .TAP)
        let question = interactor?.questions[index - 1]
        guard let viewController = questionnaireViewController(with: question) else { return }
        pageController?.setViewControllers([viewController], direction: .reverse, animated: false, completion: nil)
    }

    @IBAction func nextAction() {
        guard let vc = pageController?.viewControllers?.first as? QuestionnaireViewController else {
            return
        }
        let currentIndex = indexOf(vc)
        trackUserEvent(.SELECT, value: currentIndex, valueType: "DailyCheckin.PresentNextQuestion", action: .TAP)
        let answer = vc.currentAnswerIndex()
        didSelect(answer: answer, for: vc.questionID(), from: vc)
        guard let nextVC = next(from: vc) else {
            return
        }
        self.pageController?.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
    }
}

// MARK: - DailyCheckinQuestionsViewControllerInterface
extension DailyCheckinQuestionsViewController: DailyCheckinQuestionsViewControllerInterface {
    func setupView() {
        pageIndicatorLabel.isHidden = true
        NewThemeView.dark.apply(view)
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.delegate = self
        pageController.dataSource = self
        self.pageController = pageController
        self.addChild(pageController)
        view.insertSubview(pageController.view, belowSubview: pageContainerView)
        pageController.view.clipsToBounds = false
    }

    func showQuestions() {
        setupPageIndicatorLabel(index: .zero)
        if let viewController = questionnaireViewController(with: interactor?.questions.first) {
            pageController?.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
    }

    func showLoadingDots() {
        let dots = DotsLoadingView(frame: CGRect(x: .zero, y: .zero, width: 28, height: 28))
        dots.configure(dotsColor: .white)
        dots.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dots)
        dots.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        dots.widthAnchor.constraint(equalToConstant: 20).isActive = true
        dots.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dots.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        loadingDots = dots
        loadingDots?.animate()
    }

    func hideLoadingDots() {
        loadingDots?.stopAnimation()
    }

    @objc override public func didTapDismissButton() {
        trackUserEvent(.CLOSE, action: .TAP)
        interactor?.dismiss()
    }

    @objc private func doneAction() {
        NotificationCenter.default.post(name: .didFinishDailyCheckin, object: nil)
        guard isDoneButtonEnabled else { return }
        if let answeredCount = interactor?.questions.count, answeredCount != .zero,
            answeredCount != interactor?.answeredQuestionCount,
            let vc = pageController?.viewControllers?.first as? QuestionnaireViewController {
            let answer = vc.currentAnswerIndex()
            didSelect(answer: answer, for: vc.questionID(), from: vc)
        }
        trackUserEvent(.CONFIRM, valueType: "DailyCheckin.SaveAnswers", action: .TAP)
        interactor?.saveAnswers()
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension DailyCheckinQuestionsViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return previous(from: viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return next(from: viewController)
    }
}

extension DailyCheckinQuestionsViewController: QuestionnaireAnswer {
    func isSelecting(answer: Int, for questionIdentifier: Int?, from viewController: UIViewController) {
        // DO NOTHING
    }

    func isPresented(for questionIdentifier: Int?, from viewController: UIViewController) {
        let index = indexOf(viewController)
        if index == NSNotFound { return }
        setupPageIndicatorLabel(index: index)
        backButton.isHidden = index < 1
        let isLastQuestion = index == ((interactor?.questions.count ?? .zero) - 1)
        if isLastQuestion, let interactor = self.interactor {
            self.isDoneButtonEnabled = interactor.questions.count == (interactor.answeredQuestionCount + 1)
        } else {
            isDoneButtonEnabled = interactor?.questions.count ?? .zero == interactor?.answeredQuestionCount
        }
        refreshBottomNavigationItems()
    }

    func didSelect(answer: Int, for questionIdentifier: Int?, from viewController: UIViewController) {
        let index = indexOf(viewController)
        if index == NSNotFound { return }
        interactor?.questions[index].selectedAnswerIndex = answer
        trackUserEvent(.SELECT, value: answer, valueType: "DailyCheckin.RateQuestion", action: .SWIPE)
        isDoneButtonEnabled = interactor?.questions.count ?? .zero == interactor?.answeredQuestionCount
        refreshBottomNavigationItems()
    }

    func setupPageIndicatorLabel(index: Int) {
        pageIndicatorLabel.isHidden = false
        let total = interactor?.questions.count ?? .zero
        let attrString = NSMutableAttributedString.init()
        let currentAttrString = ThemeText.questionairePageCurrent.attributedString("\(index + 1)")
        let totalAttrString = ThemeText.questionairePageTotal.attributedString("/\(total)")
        attrString.append(currentAttrString)
        attrString.append(totalAttrString)
        pageIndicatorLabel.attributedText = attrString
    }
}
