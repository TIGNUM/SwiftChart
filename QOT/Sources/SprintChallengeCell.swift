//
//  SprintChallengeCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 06.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

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
        gotItButton.layer.borderWidth = 1
        gotItButton.layer.borderColor = UIColor.accent.cgColor
        gotItButton.corner(radius: 20)
    }

    func configure(with viewModel: SprintChallengeViewModel?) {
        self.bucketTitle.text = viewModel?.bucketTitle
        self.sprintTitle.text = viewModel?.sprintTitle
        self.sprintInfo.text = viewModel?.sprintInfo
        self.sprintStepNumber.text = String(viewModel?.sprintStepNumber ?? 0)
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
