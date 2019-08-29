//
//  SprintChallengeTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SprintChallengeTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(title: String?, durationString: String?, remoteID: Int?) {
        ThemeView.level2.apply(self)
        ThemeText.sprintTitle.apply((title ?? "").uppercased(), to: titleLabel)
        ThemeText.durationString.apply(durationString, to: durationLabel)
    }
}
