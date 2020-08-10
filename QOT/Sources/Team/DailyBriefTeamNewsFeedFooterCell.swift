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
        launchURL = URLScheme.myLibrary.launchURLWith(["teamId": "\(viewModel.team.remoteID ?? 0)"])
    }

    @IBAction func didTapActionButton(_ button: Any?) {
        guard let url = launchURL else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
