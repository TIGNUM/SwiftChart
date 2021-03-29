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
    private lazy var router = GuidedStoryRouter(viewController: self)
    @IBOutlet weak var viewContainer: UIView!

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
