//
//  GuidedStorySurveyViewController.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright © 2021 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class GuidedStorySurveyViewController: UIViewController {

    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    var interactor: GuidedStorySurveyInteractorInterface!
    weak var delegate: GuidedStoryDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }
}

// MARK: - UITableViewDelegate
extension GuidedStorySurveyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectAnswer()
        interactor.didSelectAnswer(at: indexPath.row)
        log("didSelectRowAt: \(indexPath.row)", level: .debug)
    }
}

// MARK: - UITableViewDataSource
extension GuidedStorySurveyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RadioTableViewCell = tableView.dequeueCell(for: indexPath)
        let row = indexPath.row
        let title = interactor.title(at: row)
        let subtitle = interactor.subtitle(at: row)
        let onColor = interactor.onColor(at: row)
        let isOn = interactor.isOn(at: row)
        cell.configure(title: title, subtitle: subtitle, onColor: onColor, isOn: isOn)

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

    func setAnswers() {
        tableView.reloadData()
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

// MARK: - GuidedStorySurveyDelegate
extension GuidedStorySurveyViewController: GuidedStorySurveyDelegate {
    func loadNextQuestion() {
        interactor.loadNextQuestion()
    }
}
