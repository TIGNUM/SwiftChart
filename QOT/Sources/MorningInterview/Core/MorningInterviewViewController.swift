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
    private var pageIndicatorViews: [PageIndicatorItemView?] = []

    @IBOutlet weak private var pageContainer: UIView!
    @IBOutlet weak private var indicatorStackView: UIStackView!
    @IBOutlet weak private var doneButton: UIButton!

    var interactor: MorningInterviewInteractorInterface?
    var router: MorningInterviewRouterInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.delegate = self
        pageController.dataSource = self
        self.pageController = pageController
        self.addChildViewController(pageController)
        view.insertSubview(pageController.view, belowSubview: doneButton)
        pageController.view.clipsToBounds = false
        interactor?.viewDidLoad()
        doneButton.backgroundColor = .azure
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController?.view.frame = pageContainer.frame
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let viewController = questionnaireViewController(with: questions.first) {
            pageController?.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
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
        guard let questionnaire = question else { return nil }
        return QuestionnaireViewController.viewController(with: questionnaire, delegate: self)
    }

    @IBAction func close() {
        router?.close()
    }

}

// DONE Button
extension MorningInterviewViewController {
    @IBAction func didSelectDone() {
        interactor?.saveAnswers(questions: morningInterviews)
        close()
    }

    func hasAllAnswers() -> Bool {
        return questions.count == (questions.compactMap { (question) -> Int? in
            return question.answerIndex
        }).count
    }

    func checkAnswers() {
        if hasAllAnswers() {
            showButton()
        } else {
            hideButton()
        }
    }

    func hideButton() {
        self.doneButton.transform = CGAffineTransform(translationX: 0, y: 100)
        self.doneButton.alpha = 0
    }

    func showButton() {
        UIView.animate(withDuration: Animation.duration_02, delay: Animation.duration_02,
                       options: [.curveEaseInOut], animations: {
            self.doneButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.doneButton.alpha = 1
        }, completion: nil)
    }
}

// MARK: QuestionnaireAnswer
extension MorningInterviewViewController: QuestionnaireAnswer {
    func isPresented(for questionIdentifier: Int?, from viewController: UIViewController) {
        let index = indexOf(viewController)
        pageIndicatorViews.forEach { (view) in
            view?.select(false)
        }
        pageIndicatorViews[index]?.enable(true)
        pageIndicatorViews[index]?.select(true)
        checkAnswers()
    }

    func isSelecting(answer: Any?, for questionIdentifier: Int?, from viewController: UIViewController) {
        nextPageTimer?.invalidate()
        nextPageTimer = nil
        hideButton()
    }

    func didSelect(answer: Any?, for questionIdentifier: Int?, from viewController: UIViewController) {
        guard let questionIndex = questionIdentifier else { return }
        guard let answerString = answer as? String else { return }
        questions[questionIndex].answerIndex = questions[questionIndex].answers.lastIndex(of: answerString)
        morningInterviews[questionIndex].selectedAnswerIndex = questions[questionIndex].selectedAnswerIndex()
        if questions[questionIndex].answerIndex != nil,
            let nextViewController = next(from: viewController),
            hasAllAnswers() == false {
            nextPageTimer = Timer.scheduledTimer(withTimeInterval: Animation.duration_06, repeats: false) { timer in
                self.pageController?.setViewControllers([nextViewController],
                                                        direction: .forward,
                                                        animated: true,
                                                        completion: nil)
            }
        }
        checkAnswers()
    }
}

// MARK: UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension MorningInterviewViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let previous = previous(from: viewController) else { return nil }
        nextPageTimer?.invalidate()
        nextPageTimer = nil
        return previous
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let next = next(from: viewController) else { return nil }
        nextPageTimer?.invalidate()
        nextPageTimer = nil
        return next
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        nextPageTimer?.invalidate()
        nextPageTimer = nil
    }
}

// MARK: MorningInterviewViewControllerInterface
extension MorningInterviewViewController: MorningInterviewViewControllerInterface {
    func setQuestions(_ questions: [MorningInterview.Question]) {
        indicatorStackView.removeSubViews()
        pageIndicatorViews.removeAll()
        self.morningInterviews = questions
        var questionIndex: Int = 0
        for question in questions {
            let answers = question.answers.compactMap({ (answer) -> String? in
                return answer.title
            })
            let descriptions = question.answers.compactMap({ (answer) -> String? in
                return answer.subtitle ?? ""
            })
            var color = UIColor.gray
            if let chartType = ChartType(rawValue: question.key ?? "") {
                switch chartType {
                case .intensityRecoveryWeek,
                     .intensityRecoveryMonth: color =  UIColor.recoveryGreen
                case .intensityLoadWeek,
                     .intensityLoadMonth: color = UIColor.recoveryRed
                default:
                    break
                }
            }
            self.questions.append(MorningQuestion(questionID: questionIndex,
                                                         questionString: question.title,
                                                         answers: answers,
                                                         descriptions: descriptions,
                                                         answerIndex: nil,
                                                         fillColor: color))
            let itemView = PageIndicatorItemView.viewWithTitle(String(pageIndicatorViews.count + 1), questionIndex) { [weak self] itemID in
                guard let question = self?.questions[itemID] else { return }
                guard let nextViewController = self?.questionnaireViewController(with: question) else { return }
                self?.pageController?.setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)
            }
            if let view = itemView {
                pageIndicatorViews.append(view)
                view.enable(false)
                indicatorStackView.addArrangedSubview(view)
                view.alpha = 0
                UIView.animate(withDuration: Animation.duration_02,
                               delay: Animation.duration_02 * Double(questionIndex),
                               options: [.curveEaseInOut],
                               animations: {
                                view.alpha = 1
                }, completion: nil)
            }
            questionIndex = questionIndex + 1
        }
        hideButton()
    }
}
