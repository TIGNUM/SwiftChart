//
//  TeamToBeVisionNullStateView.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol TeamToBeVisionNullStateViewProtocol: class {
    func editTeamVisionAction()
}

final class TeamToBeVisionNullStateView: UIView {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var toBeVisionLabel: UILabel!
    @IBOutlet weak var teamNullStateImage: UIImageView!

    weak var delegate: TeamToBeVisionNullStateViewProtocol?

    func setupView(with header: String, teamName: String?, message: String, delegate: TeamToBeVisionNullStateViewProtocol?) {
        self.delegate = delegate
        ThemeView.level2.apply(self)
        ThemeText.tbvSectionHeader.apply(AppTextService.get(.my_x_team_tbv_section_new_header_title).replacingOccurrences(of: "{$TEAM_NAME)", with: teamName?.uppercased() ?? ""), to: toBeVisionLabel)
        ThemeText.tbvHeader.apply(header, to: headerLabel)
        ThemeText.tbvVision.apply(message, to: detailLabel)
    }
}
