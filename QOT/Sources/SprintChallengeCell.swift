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
    @IBOutlet weak var outOf5Label: UILabel!
    @IBOutlet weak var gotItButton: AnimatedButton!
    private var currentSprint: QDMSprint?
    var relatedStrategiesModels: [SprintChallengeViewModel.RelatedStrategiesModel]? = []
    var showMore = false
    @IBOutlet weak var showMoreButton: AnimatedButton!
    @IBOutlet weak var constraintContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var gotItButtonHeight: NSLayoutConstraint!
    private var observers: [NSKeyValueObservation] = []
    @IBAction func gotItTapped(_ sender: Any) {
        ThemeView.audioPlaying.apply(gotItButton)
        gotItButton.layer.borderWidth = 0
        gotItButton.isEnabled = false
        delegate?.didPressGotItSprint(sprint: currentSprint!)
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
        tableView.tableFooterView = UIView()
        self.sprintInfo?.numberOfLines = 3
        contentView.backgroundColor = .carbon
        tableView.registerDequeueable(SprintChallengeTableViewCell.self)
        self.sprintInfo?.lineBreakMode = .byWordWrapping
        ThemeBorder.accent.apply(gotItButton)
        updateGotItButton()
        tableView.setNeedsLayout()
        observers = [tableView.observe(\.contentSize, options: [.new]) { [weak self] (tableView, change) in
            self?.checkScroll()
            }
        ]
        ThemeBorder.accent.apply(gotItButton)
        skeletonManager.addSubtitle(sprintTitle)
        skeletonManager.addSubtitle(sprintInfo)
        skeletonManager.addOtherView(tableView)
        skeletonManager.addOtherView(gotItButton)
        skeletonManager.addOtherView(sprintStepNumber)
        skeletonManager.addOtherView(outOf5Label)
        skeletonManager.addOtherView(showMoreButton)
        tableView.delegate = self
        tableView.dataSource = self
        ThemeView.level2.apply(self)
    }

    private func checkScroll() {
        constraintContainerHeight.constant = tableView.contentSize.height
        tableView.setNeedsUpdateConstraints()
    }

    func configure(with viewModel: SprintChallengeViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        if model.relatedStrategiesModels.isEmpty == true {
            constraintContainerHeight.constant = 0
            tableView.setNeedsLayout()
        }
        ThemeText.dailyBriefTitle.apply((model.bucketTitle ?? "").uppercased(), to: bucketTitle)
        ThemeText.sprintName.apply(model.sprintTitle, to: sprintTitle)
        ThemeText.sprintText.apply(model.sprintInfo, to: sprintInfo)
        ThemeText.quotation.apply(String(model.sprintStepNumber ?? 0), to: sprintStepNumber)
        self.relatedStrategiesModels = model.relatedStrategiesModels
        self.currentSprint = model.sprint
        updateGotItButton()
    }

    private func updateGotItButton() {
        if currentSprint?.doneForToday == true {
            ThemeView.audioPlaying.apply(gotItButton)
            gotItButton.layer.borderWidth = 0
            gotItButton.isEnabled = false
        } else {
            ThemeBorder.accent.apply(gotItButton)
            ThemeView.sprints.apply(gotItButton)
            gotItButton.isEnabled = true
        }
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
                       remoteID: relatedStrategiesModels?[indexPath.row].contentId ?? relatedStrategiesModels?[indexPath.row].contentItemId,
                       section: relatedStrategiesModels?[indexPath.row].section,
                       format: relatedStrategiesModels?[indexPath.row].format,
                       numberOfItems: relatedStrategiesModels?[indexPath.row].numberOfItems ?? 0)
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
