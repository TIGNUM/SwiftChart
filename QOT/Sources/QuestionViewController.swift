//
//  QuestionViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 21.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class QuestionViewController: UIViewController {

    // MARK: - Properties

    var interactor: QuestionInteractorInterface?
    @IBOutlet weak var questionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .carbonDark
        questionLabel.textColor = .sand
        interactor?.randomQuestion(completion: { [weak self] (title) in
            self?.questionLabel.text = title
        })
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        trackPage()
    }
}

// MARK: - Private

private extension  QuestionViewController {
}
// MARK: - CoachViewControllerInterface

extension  QuestionViewController: QuestionViewControllerInterface {

}
