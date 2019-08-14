//
//  SolveReminderCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class SolveReminderCell: UITableViewCell, UITableViewDelegate, Dequeueable, UITableViewDataSource {
    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var twoDayAgo: UILabel!
    @IBOutlet private weak var question1: UILabel!
    @IBOutlet private weak var question2: UILabel!
    @IBOutlet private weak var question3: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    private var solveViewModels: [SolveReminderCellViewModel.SolveViewModel]? = []
    var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.registerDequeueable(SolveTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }

    func configure(with viewModel: SolveReminderCellViewModel?) {
        self.bucketTitle.text = viewModel?.bucketTitle
        self.twoDayAgo.text = viewModel?.twoDayAgo
        self.question1.text = viewModel?.question1
        self.question2.text = viewModel?.question2
        self.question3.text = viewModel?.question3
        self.solveViewModels = viewModel?.solveViewModels
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solveViewModels?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SolveTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: solveViewModels?[indexPath.row].title, date: solveViewModels?[indexPath.row].date, solve: solveViewModels?[indexPath.row].solve)
        cell.backgroundColor = .carbon
        cell.delegate = self.delegate
        return cell
    }
}
