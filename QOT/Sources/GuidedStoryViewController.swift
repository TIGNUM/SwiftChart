//
//  GuidedStoryViewController.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class GuidedStoryViewController: UIViewController {

    // MARK: - Properties
    var interactor: GuidedStoryInteractorInterface!
    var router: GuidedStoryRouter!
    weak var surveyDelegate: GuidedStorySurveyDelegate?
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var buttonViewSurvey: UIView!
    @IBOutlet weak var buttonViewJourney: UIView!
    @IBOutlet weak var nextButtonSurvey: UIButton!
    @IBOutlet weak var nextButtonJourney: UIButton!
    @IBOutlet weak var skipButtonJourney: UIButton!
    @IBOutlet weak var previousButtonJourney: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }
}

// MARK: - Private
private extension GuidedStoryViewController {
    func enableNextButtonSurvey() {
        nextButtonSurvey.isEnabled = true
        nextButtonSurvey.backgroundColor = .blue
    }

    func disableNextButtonSurvey() {
        nextButtonSurvey.isEnabled = false
        nextButtonSurvey.backgroundColor = .gray
    }

    func setupSurveyView() {
        buttonViewJourney.isHidden = true
    }

    func setupJourneyView() {
        buttonViewJourney.isHidden = false
        buttonViewSurvey.isHidden = true
        previousButtonJourney.isHidden = true
    }

    func setCurrentPageIndicator(_ page: Int) {
        pageControl.currentPage = page
    }
}

// MARK: - Actions
private extension GuidedStoryViewController {
    @IBAction func didTabNextSurvey(_ sender: Any) {
        interactor.didTabNextSurvey()
        disableNextButtonSurvey()
        setCurrentPageIndicator(interactor.currentPage)
    }

    @IBAction func didTabNextJourney(_ sender: Any) {
        interactor.didTabNextJourney()
    }

    @IBAction func didTabPreviousJourney(_ sender: Any) {
        interactor.didTabPreviousJourney()
        setCurrentPageIndicator(interactor.currentPage)
    }

    @IBAction func didTabSkipJourney(_ sender: Any) {
        interactor.didTabSkipJourney()
    }
}

// MARK: - GuidedStoryViewControllerInterface
extension GuidedStoryViewController: GuidedStoryViewControllerInterface {
    func setupView() {
        setupSurveyView()
        router.showSurvey()
    }

    func showJourney() {
        setupJourneyView()
        router.showJourney()
    }

    func loadNextQuestion() {
        surveyDelegate?.loadNextQuestion()
    }

    func setupPageIndicator(pageCount: Int) {
        pageControl.numberOfPages = pageCount
    }
}

// MARK: - GuidedStoryDelegate
extension GuidedStoryViewController: GuidedStoryDelegate {
    func didSelectAnswer() {
        enableNextButtonSurvey()
    }

    func didStartJourney() {

    }
}
