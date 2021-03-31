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
    weak var journeyDelegate: GuidedStoryJourneyDelegate?
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

    func updatePreviousButtonVisibility() {
        previousButtonJourney.isHidden = interactor.previousButtonJourneyIsHidden
    }
}

// MARK: - Actions
private extension GuidedStoryViewController {
    @IBAction func didTapNextSurvey(_ sender: Any) {
        interactor.didTapNextSurvey()
        disableNextButtonSurvey()
        updatePageIndicator(interactor.currentPage)
    }

    @IBAction func didTapNextJourney(_ sender: Any) {
        interactor.didTapNextJourney()
        journeyDelegate?.scrollToItem(at: interactor.currentJourneyIndex)
        updatePreviousButtonVisibility()
    }

    @IBAction func didTapPreviousJourney(_ sender: Any) {
        interactor.didTapPreviousJourney()
        journeyDelegate?.scrollToItem(at: interactor.currentJourneyIndex)
        updatePreviousButtonVisibility()
    }

    @IBAction func didTapSkipJourney(_ sender: Any) {
        interactor.didTapSkipJourney()
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

    func updatePageIndicator(_ page: Int) {
        pageControl.currentPage = page
    }
}

// MARK: - GuidedStoryDelegate
extension GuidedStoryViewController: GuidedStoryDelegate {
    func didSelectAnswer() {
        enableNextButtonSurvey()
    }

    func didStartJourney() {

    }

    func didUpdateCollectionViewCurrentIndex(_ index: Int) {
        interactor.didUpdateJourneyCurrentIndex(index)
        updatePreviousButtonVisibility()
    }
}
