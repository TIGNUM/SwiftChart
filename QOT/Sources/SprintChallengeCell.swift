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

    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var sprintTitle: UILabel!
    @IBOutlet private weak var sprintInfo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var sprintStepNumber: UILabel!
    @IBOutlet weak var outOf5Label: UILabel!
    @IBOutlet weak var showMoreButton: AnimatedButton!
    @IBOutlet weak var constraintContainerHeight: NSLayoutConstraint!

    weak var delegate: DailyBriefViewControllerDelegate?
    private var currentSprint: QDMSprint?
    private var observers: [NSKeyValueObservation] = []
    var relatedItemsModels = [SprintChallengeViewModel.RelatedItemsModel]()
    var showMore = false

    @IBAction func showMoreButton(_ sender: Any) {
        showMore = !showMore
        self.sprintInfo?.numberOfLines = showMore ? 0 : 3
        self.showMoreButton.setTitle(showMore ? AppTextService.get(.daily_brief_section_sprint_challenge_button_show_less) : AppTextService.get(.daily_brief_section_sprint_challenge_button_show_more), for: .normal)
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
        tableView.setNeedsLayout()
        observers = [tableView.observe(\.contentSize, options: [.new]) { [weak self] (tableView, change) in
            self?.checkScroll()
            }
        ]
        skeletonManager.addSubtitle(sprintTitle)
        skeletonManager.addSubtitle(sprintInfo)
        skeletonManager.addOtherView(tableView)
        skeletonManager.addOtherView(sprintStepNumber)
        skeletonManager.addOtherView(outOf5Label)
        skeletonManager.addOtherView(showMoreButton)
        tableView.delegate = self
        tableView.dataSource = self
        ThemeView.level2.apply(self)
    }

    func configure(with viewModel: SprintChallengeViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        self.relatedItemsModels = model.relatedStrategiesModels
        self.currentSprint = model.sprint
        if model.relatedStrategiesModels.isEmpty == true {
            constraintContainerHeight.constant = 0
            tableView.setNeedsLayout()
        }
        ThemeText.dailyBriefTitle.apply((model.bucketTitle ?? "").uppercased(), to: bucketTitle)
        ThemeText.sprintName.apply(model.sprintTitle, to: sprintTitle)
        ThemeText.sprintText.apply(model.sprintInfo, to: sprintInfo)
        ThemeText.quotation.apply(String(model.sprintStepNumber ?? 0), to: sprintStepNumber)
    }

    private func checkScroll() {
        constraintContainerHeight.constant = tableView.contentSize.height
        tableView.setNeedsUpdateConstraints()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatedItemsModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let relatedItem = relatedItemsModels.at(index: indexPath.row)
        let cell: SprintChallengeTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.selectedBackgroundView = backgroundView
        cell.setSelectedColor(.accent, alphaComponent: 0.1)
        cell.configure(title: relatedItem?.title,
                       durationString: relatedItem?.durationString,
                       remoteID: relatedItem?.contentId ?? relatedItemsModels[indexPath.row].contentItemId,
                       section: relatedItem?.section,
                       format: relatedItem?.format,
                       numberOfItems: relatedItem?.numberOfItems ?? 0)
        cell.accessoryView = UIImageView(image: R.image.ic_disclosure_accent())
        cell.delegate = self.delegate
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard relatedItemsModels.count > indexPath.row else { return }
        let relatedItem = relatedItemsModels.at(index: indexPath.row)
        if let contentItemId = relatedItem?.contentItemId,
            let launchURL = URLScheme.contentItem.launchURLWithParameterValue(String(contentItemId)) {
            UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
            switch relatedItem?.format {
            case .video:
                var userEventTrack = QDMUserEventTracking()
                userEventTrack.name = .PLAY
                userEventTrack.value = relatedItem?.contentItemId
                userEventTrack.valueType = .VIDEO
                userEventTrack.action = .TAP
                NotificationCenter.default.post(name: .reportUserEvent, object: userEventTrack)
            default:
                break
            }
        } else if let contentCollectionId = relatedItem?.contentId {
            if relatedItem?.section == .LearnStrategies {
                delegate?.presentStrategyList(strategyID: contentCollectionId)
            } else if relatedItem?.section == .QOTLibrary {
                delegate?.openTools(toolID: contentCollectionId)
            } else if relatedItem?.link !=  nil {
                relatedItem?.link?.launch()
            } else if let launchURL = URLScheme.randomContent.launchURLWithParameterValue(String(contentCollectionId)) {
                UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
            }
        }
    }
}
