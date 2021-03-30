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
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }
}

// MARK: - Private
private extension GuidedStoryViewController {
    func enableNextButton() {
        nextButton.isEnabled = true
        nextButton.backgroundColor = .blue
    }

    func disableNextButton() {
        nextButton.isEnabled = false
        nextButton.backgroundColor = .gray
    }
}

// MARK: - Actions
private extension GuidedStoryViewController {
    @IBAction func didTabNext(_ sender: Any) {
        interactor.didTabNext()
        disableNextButton()
    }

    @IBAction func didTabPrevious(_ sender: Any) {
        interactor.didTabPrevious()
    }
}

// MARK: - GuidedStoryViewControllerInterface
extension GuidedStoryViewController: GuidedStoryViewControllerInterface {
    func setupView() {
        router.showSurvey()
    }

    func showJourney() {
        router.showJourney()
    }

    func loadNextQuestion() {
        surveyDelegate?.loadNextQuestion()
    }
}

// MARK: - GuidedStoryDelegate
extension GuidedStoryViewController: GuidedStoryDelegate {
    func didSelectAnswer() {
        enableNextButton()
    }
}
