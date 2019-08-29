//
//  SprintChallengeCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 06.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class SprintChallengeCell: UITableViewCell, UITableViewDelegate, Dequeueable, UITableViewDataSource {
    var delegate: DailyBriefViewControllerDelegate?
    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var sprintTitle: UILabel!
    @IBOutlet private weak var sprintInfo: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var sprintStepNumber: UILabel!
    @IBOutlet weak var gotItButton: UIButton!
    var relatedStrategiesModels: [SprintChallengeViewModel.RelatedStrategiesModel]? = []

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .carbon
        tableView.registerDequeueable(SprintChallengeTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        ThemeBorder.accent.apply(gotItButton)
    }

    func configure(with viewModel: SprintChallengeViewModel?) {
        ThemeView.level2.apply(self)
        ThemeText.dailyBriefTitle.apply((viewModel?.bucketTitle ?? "").uppercased(), to: bucketTitle)
        ThemeText.sprintName.apply(viewModel?.sprintTitle, to: sprintTitle)
        ThemeText.sprintText.apply(viewModel?.sprintInfo, to: sprintInfo)
        ThemeText.quotation.apply(String(viewModel?.sprintStepNumber ?? 0), to: sprintStepNumber)
        self.relatedStrategiesModels = viewModel?.relatedStrategiesModels
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SprintChallengeTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: relatedStrategiesModels?[indexPath.row].title, durationString: relatedStrategiesModels?[indexPath.row].durationString, remoteID: relatedStrategiesModels?[indexPath.row].remoteID)
        cell.backgroundColor = .carbon
        cell.delegate = self.delegate
        return cell
    }

}
