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
    private qlazy var router = GuidedStoryRouter(viewController: self)
    @IBOutlet private weak var viewContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }
}

// MARK: - Private
private extension GuidedStoryViewController {

}

// MARK: - Actions
private extension GuidedStoryViewController {
    @IBAction func didTabNext(_ sender: Any) {
        router.showJourney()
    }
}

// MARK: - GuidedStoryViewControllerInterface
extension GuidedStoryViewController: GuidedStoryViewControllerInterface {
    func setupView() {
        router.setViewContainer(viewContainer)
        router.showSurvey()
    }
}
