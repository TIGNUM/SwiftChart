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
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }
}

// MARK: - Private
private extension GuidedStoryViewController {
    func activateNextButton() {
        nextButton.isEnabled = true
        nextButton.backgroundColor = .blue
    }
}

// MARK: - Actions
private extension GuidedStoryViewController {
    @IBAction func didTabNext(_ sender: Any) {
        interactor.didTabNext()
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
}

// MARK: - GuidedStoryDelegate
extension GuidedStoryViewController: GuidedStoryDelegate {
    func didSelectAnswer() {
        activateNextButton()
    }
}
