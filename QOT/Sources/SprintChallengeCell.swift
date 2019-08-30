//
//  SprintChallengeCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 06.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class SprintChallengeCell: UITableViewCell, UITableViewDelegate, Dequeueable, UITableViewDataSource {

    weak var delegate: DailyBriefViewControllerDelegate?
    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var sprintTitle: UILabel!
    @IBOutlet private weak var sprintInfo: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var sprintStepNumber: UILabel!
    @IBOutlet weak var gotItButton: UIButton!
    private var currentSprint: QDMSprint?
    var relatedStrategiesModels: [SprintChallengeViewModel.RelatedStrategiesModel]? = []

    @IBAction func gotItPressed(_ sender: Any) {
        delegate?.didPressGotItSprint(sprint: currentSprint!)
        gotItButton.isHidden = true
    }

    @IBAction func showMoreButton(_ sender: Any) {
        self.sprintInfo?.numberOfLines = 0
        self.sprintInfo?.sizeToFit()
        delegate?.reloadSprintCell(cell: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .carbon
        tableView.registerDequeueable(SprintChallengeTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        self.sprintInfo?.lineBreakMode = .byWordWrapping
        self.sprintInfo?.sizeToFit()
        ThemeBorder.accent.apply(gotItButton)
    }

    func configure(with viewModel: SprintChallengeViewModel?) {
        ThemeView.level2.apply(self)
        ThemeText.dailyBriefTitle.apply((viewModel?.bucketTitle ?? "").uppercased(), to: bucketTitle)
        let lowercaseTitle = viewModel?.sprintTitle?.lowercased()
        ThemeText.sprintName.apply((lowercaseTitle?.prefix(1).uppercased() ?? "") + String(lowercaseTitle?.dropFirst() ?? ""), to: sprintTitle)
        ThemeText.sprintText.apply(viewModel?.sprintInfo, to: sprintInfo)
        ThemeText.quotation.apply(String(viewModel?.sprintStepNumber ?? 0), to: sprintStepNumber)
        self.relatedStrategiesModels = viewModel?.relatedStrategiesModels
        self.currentSprint = viewModel?.sprint
        gotItButton.isHidden = self.currentSprint?.doneForToday == true
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatedStrategiesModels?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SprintChallengeTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: relatedStrategiesModels?[indexPath.row].title,
                       durationString: relatedStrategiesModels?[indexPath.row].durationString,
                       remoteID: relatedStrategiesModels?[indexPath.row].remoteID,
                       section: relatedStrategiesModels?[indexPath.row].section,
                       format: relatedStrategiesModels?[indexPath.row].format,
                       numberOfItems: relatedStrategiesModels?[indexPath.row].numberOfItems ?? 0)
        cell.backgroundColor = .carbon
        cell.delegate = self.delegate
        return cell
    }
}
