//
//  DailyBriefTeamNewsFeedFooterCell.swift
//  QOT
//
//  Created by Sanggeon Park on 06.08.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

class DailyBriefTeamNewsFeedFooterCell: BaseDailyBriefCell {
    @IBOutlet private weak var button: RoundedButton?
    var launchURL: URL?
    var teamId: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        if button != nil {
            skeletonManager.addSubtitle(button!)
        }
    }

    func configure(with viewModel: TeamNewsFeedDailyBriefViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        skeletonManager.hide()
        button?.setTitle(viewModel.actionButtonTitle, for: .normal)
        teamId = viewModel.team.remoteID ?? 0
        launchURL = URLScheme.myLibrary.launchURLWith(["teamId": "\(teamId)"])
    }

    @IBAction func didTapActionButton(_ button: Any?) {
        guard let url = launchURL else { return }
        trackUserEvent(.OPEN_TEAM_LIBRARY, value: teamId, valueType: .TEAM, action: .TAP)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
