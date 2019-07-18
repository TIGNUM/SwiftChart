//
//  MorningInterviewViewController.swift
//  RatingAnimation
//
//  Created by Sanggeon Park on 23.10.18.
//  Copyright © 2018 Sanggeon Park. All rights reserved.
//

import UIKit

final class MorningInterviewViewController: UIViewController {
    private var pageController: UIPageViewController?
    private var questions: [MorningQuestion] = []
    private var morningInterviews: [MorningInterview.Question] = []
    private var nextPageTimer: Timer?
    static var page: PageName = .morningInterview

    @IBOutlet weak private var pageContainer: UIView!
    @IBOutlet weak private var stackView: UIView!
    @IBOutlet weak private var pageIndicator: UIPageControl!
    @IBOutlet weak private var previousButton: UIButton!
    @IBOutlet weak private var nextButton: UIButton!
    @IBOutlet weak private var touchAssistantImage: UIView!

    var interactor: MorningInterviewInteractorInterface?
    var router: MorningInterviewRouterInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.delegate = self
        pageController.dataSource = self
        self.pageController = pageController
        self.addChildViewController(pageController)
        view.insertSubview(pageController.view, belowSubview: stackView)
        pageController.view.clipsToBounds = false
        previousButton.titleLabel?.font = R.font.apercuBold(size: 14)
        nextButton.titleLabel?.font = R.font.apercuBold(size: 14)
        interactor?.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController?.view.frame = pageContainer.frame
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let viewController = questionnaireViewController(with: questions.first) {
            pageController?.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
        UIView.animate(withDuration: Animation.duration_02,
                       delay: Animation.duration_1,
                       options: .curveEaseInOut,
                       animations: {
            self.touchAssistantImage.alpha = 1
        }, completion: { finished in
            self.touchAssistantImage.verticalBounce(3,
                                                    offset: self.touchAssistantImage.frame.height,
                                                    duration: Animation.duration_075)
        })
    }

    func indexOf(_ viewController: UIViewController?) -> Int {
        guard let vc = viewController as? QuestionnaireViewController else {
            return NSNotFound
        }
        return vc.questionID()
    }

    func previous(from viewController: UIViewController) -> UIViewController? {
        var currentIndex = indexOf(viewController)
        if currentIndex == NSNotFound {
            currentIndex = questions.count
        }

        let previousIndex = currentIndex - 1
        if previousIndex < 0 {
            return nil
        }

        return questionnaireViewController(with: questions[previousIndex])
    }

    func next(from viewController: UIViewController) -> UIViewController? {
        let currentIndex = indexOf(viewController)
        if currentIndex == NSNotFound {
            return nil
        }

        if questions[currentIndex].answerIndex == nil {
            return nil
        }

        let nextIndex = currentIndex + 1
        if nextIndex >= questions.count {
            return nil
        }

        return questionnaireViewController(with: questions[nextIndex])
    }

    func questionnaireViewController(with question: MorningQuestion?) -> UIViewController? {
        return nil
    }

    @IBAction func close() {
        router?.close()
    }
}

// DONE Button
extension MorningInterviewViewController {

    @IBAction func didSelectDone() {
        if hasAllAnswers() {
            interactor?.saveAnswers(questions: morningInterviews)
            close()
            return
        }
    }

    @IBAction func didSelectPrevious() {
        guard let currentViewController = pageController?.viewControllers?.first else { return }
        let index = indexOf(currentViewController)
        guard index > 0 else { return }
        nextPageTimer?.invalidate()
        nextPageTimer = nil

        let question = questions[index - 1]
        guard let viewController = questionnaireViewController(with: question) else { return }
        pageController?.setViewControllers([viewController], direction: .reverse, animated: false, completion: nil)
    }

    func hasAllAnswers() -> Bool {
        return questions.count == (questions.compactMap { (question) -> Int? in
            return question.answerIndex
        }).count
    }

    func checkAnswers() {
        guard let currentViewController = pageController?.viewControllers?.first else { return }
        UIView.animate(withDuration: Animation.duration_01) {
            let currentPageIndex = self.indexOf(currentViewController)
            self.previousButton.setTitle(R.string.localized.morningControllerPreviousButton(), for: .normal)

            if currentPageIndex > 0 {
                self.previousButton.isUserInteractionEnabled = true
                self.previousButton.alpha = 1
            } else {
                self.previousButton.isUserInteractionEnabled = false
                self.previousButton.alpha = 0
            }
            if self.hasAllAnswers() {
                self.nextButton.isUserInteractionEnabled = true
                self.nextButton.alpha = 1
            } else {
                self.nextButton.alpha = 0
                self.nextButton.isUserInteractionEnabled = false
            }
        }
    }

    @IBAction func pageIndicatorValueChagned() {
        guard let currentViewController = pageController?.viewControllers?.first else { return }
        let currentPageIndex = indexOf(currentViewController)
        let newPageIndex = pageIndicator.currentPage
        let direction: UIPageViewController.NavigationDirection = currentPageIndex < newPageIndex ? .forward : .reverse
        if currentPageIndex > newPageIndex, previous(from: currentViewController) == nil {
            pageIndicator.currentPage = currentPageIndex
            return
        } else if currentPageIndex < newPageIndex, next(from: currentViewController) == nil {
            pageIndicator.currentPage = currentPageIndex
            return
        } else if currentPageIndex == newPageIndex {
            return
        }

        nextPageTimer?.invalidate()
        nextPageTimer = nil

        let question = questions[newPageIndex]
        guard let nextViewController = questionnaireViewController(with: question) else { return }
        pageController?.setViewControllers([nextViewController], direction: direction, animated: false, completion: nil)
    }
}

// MARK: QuestionnaireAnswer
extension MorningInterviewViewController: QuestionnaireAnswer {
    func isPresented(for questionIdentifier: Int?, from viewController: UIViewController) {}

    func isSelecting(answer: Int, for questionIdentifier: Int?, from viewController: UIViewController) {}

    func didSelect(answer: Int, for questionIdentifier: Int?, from viewController: UIViewController) {}
}

// MARK: UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension MorningInterviewViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
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

//extension MorningInterviewViewController: UIPageViewControllerDelegate

// MARK: MorningInterviewViewControllerInterface
extension MorningInterviewViewController: MorningInterviewViewControllerInterface {
    func setQuestions(_ questions: [MorningInterview.Question]) {
        self.morningInterviews = questions
        pageIndicator.numberOfPages = questions.count
        for (index, question) in questions.enumerated() {
            let answers = question.answers.compactMap({ (answer) -> String? in
                return answer.title
            })
            let descriptions = question.answers.compactMap({ (answer) -> String? in
                return answer.subtitle ?? ""
            })
            var topColor = UIColor.recoveryGreen
            var bottomColor = UIColor.recoveryRed
            if let chartType = ChartType(rawValue: question.key ?? "") {
                switch chartType {
                case .intensityLoadWeek,
                     .intensityLoadMonth:
                    topColor = UIColor.recoveryRed
                    bottomColor = UIColor.recoveryGreen
                default:
                    break
                }
            }
            self.questions.append(MorningQuestion(questionID: index,
                                                  questionString: question.title,
                                                  attributedQuestionString: question.htmlTitle?.convertHtml(),
                                                  answers: answers,
                                                  descriptions: descriptions,
                                                  answerIndex: nil,
                                                  fillColor: UIColor.guideCardToDoBackground,
                                                  topColor: topColor,
                                                  bottomColor: bottomColor))
        }
    }
}
