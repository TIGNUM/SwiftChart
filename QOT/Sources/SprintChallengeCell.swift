//
//  SprintChallengeCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 06.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class SprintChallengeCell: BaseDailyBriefCell, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: DailyBriefViewControllerDelegate?
    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var sprintTitle: UILabel!
    @IBOutlet private weak var sprintInfo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var sprintStepNumber: UILabel!
    @IBOutlet weak var gotItButton: AnimatedButton!
    private var currentSprint: QDMSprint?
    var relatedStrategiesModels: [SprintChallengeViewModel.RelatedStrategiesModel]? = []
    var showMore = false
    @IBOutlet weak var showMoreButton: AnimatedButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var gotItButtonHeight: NSLayoutConstraint!
    @IBAction func gotItPressed(_ sender: Any) {
        delegate?.didPressGotItSprint(sprint: currentSprint!)
        gotItButton.isHidden = true
        gotItButtonHeight.constant = 0
    }

    @IBAction func showMoreButton(_ sender: Any) {
        showMore = !showMore
        self.sprintInfo?.numberOfLines = showMore ? 0 : 3
        self.showMoreButton.setTitle(showMore ? "Show Less" : "Show More", for: .normal)
        self.sprintInfo?.sizeToFit()
        delegate?.reloadSprintCell(cell: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .carbon
        tableView.registerDequeueable(SprintChallengeTableViewCell.self)
        self.sprintInfo?.lineBreakMode = .byWordWrapping
        self.sprintInfo?.sizeToFit()
        ThemeBorder.accent.apply(gotItButton)
    }

    func configure(with viewModel: SprintChallengeViewModel?) {
        tableView.delegate = self
        tableView.dataSource = self
        ThemeView.level2.apply(self)
        if viewModel?.relatedStrategiesModels.isEmpty == true {
            tableView.isHidden = true
            tableViewHeight.constant = 0
            tableView.setNeedsLayout()
        }
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
        cell.selectedBackgroundView = backgroundView
        cell.setSelectedColor(.accent, alphaComponent: 0.1)
        cell.configure(title: relatedStrategiesModels?[indexPath.row].title,
                       durationString: relatedStrategiesModels?[indexPath.row].durationString,
                       remoteID: relatedStrategiesModels?[indexPath.row].contentId,
                       section: relatedStrategiesModels?[indexPath.row].section,
                       format: relatedStrategiesModels?[indexPath.row].format,
                       numberOfItems: relatedStrategiesModels?[indexPath.row].numberOfItems ?? 0)
        cell.backgroundColor = .carbon
        cell.delegate = self.delegate
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let relatedStrategy = relatedStrategiesModels?[indexPath.row] else { return }
        if let contentItemId = relatedStrategy.contentItemId,
            let launchURL = URLScheme.contentItem.launchURLWithParameterValue(String(contentItemId)) {
                UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
        } else if let contentCollectionId = relatedStrategy.contentId {
            if relatedStrategy.section == .LearnStrategies {
                delegate?.openStrategyFromSprint(strategyID: contentCollectionId)
            } else if relatedStrategy.section == .QOTLibrary {
                delegate?.openToolFromSprint(toolID: contentCollectionId)
            } else if let launchURL = URLScheme.randomContent.launchURLWithParameterValue(String(contentCollectionId)) {
                UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
            }
        }
    }
}
