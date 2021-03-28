//
//  GuidedStorySurveyViewController.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright © 2021 Tignum. All rights reserved.
//

import UIKit

final class GuidedStorySurveyViewController: UIViewController {

    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    var interactor: GuidedStorySurveyInteractorInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }
}

// MARK: - UITableViewDelegate
extension GuidedStorySurveyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - UITableViewDataSource
extension GuidedStorySurveyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RadioTableViewCell = tableView.dequeueCell(for: indexPath)
        return cell
    }
}

// MARK: - GudidedStorySurveyViewControllerInterface
extension GuidedStorySurveyViewController: GuidedStorySurveyViewControllerInterface {
    func setupView() {
       setupTableView()
    }

    func setQuestionLabel(_ question: String?) {
        questionLabel.text = question
    }
}

// MARK: - Private
private extension GuidedStorySurveyViewController {
    func setupTableView() {
        tableView.registerDequeueable(RadioTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}
