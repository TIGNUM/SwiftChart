//
//  SolveReminderCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class SolveReminderCell: BaseDailyBriefCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var twoDayAgo: UILabel!
    @IBOutlet private weak var question1: UILabel!
    @IBOutlet private weak var question2: UILabel!
    @IBOutlet private weak var question3: UILabel!
    private var solveViewModels: [SolveReminderCellViewModel.SolveViewModel]? = []
    weak var delegate: DailyBriefViewControllerDelegate?
    @IBOutlet private weak var tableView: UITableView!

    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.registerDequeueable(SolveTableViewCell.self)
    }

    func configure(with viewModel: SolveReminderCellViewModel?) {
        ThemeText.dailyBriefTitle.apply((viewModel?.bucketTitle ?? "").uppercased(), to: bucketTitle)
        ThemeText.solveQuestions.apply(viewModel?.question1, to: question1)
        ThemeText.solveQuestions.apply(viewModel?.question2, to: question2)
        ThemeText.solveQuestions.apply(viewModel?.question3, to: question3)
        ThemeText.sprintText.apply(viewModel?.twoDayAgo, to: twoDayAgo)
        ThemeView.level2.apply(tableView)
        self.solveViewModels = viewModel?.solveModels
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solveViewModels?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SolveTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.selectedBackgroundView = backgroundView
        cell.setSelectedColor(.accent, alphaComponent: 0.1)
        cell.configure(title: solveViewModels?[indexPath.row].title,
                       date: solveViewModels?[indexPath.row].date,
                       solve: solveViewModels?[indexPath.row].solve)
        cell.delegate = self.delegate
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let solve = solveViewModels?[indexPath.row].solve else { return }
        delegate?.showSolveResults(solve: solve)
    }
}
