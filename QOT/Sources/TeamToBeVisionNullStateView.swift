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
//    func autogenerateTeamVisionAction()
}

final class TeamToBeVisionNullStateView: UIView {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var toBeVisionLabel: UILabel!
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet weak var teamNullStateImage: UIImageView!

    weak var delegate: TeamToBeVisionNullStateViewProtocol?

    func setupView(with header: String, message: String, writeMessage: String, delegate: TeamToBeVisionNullStateViewProtocol?) {
        self.delegate = delegate
        ThemeView.level2.apply(self)
        ThemeText.tbvSectionHeader.apply(AppTextService.get(.my_qot_my_tbv_section_header_title), to: toBeVisionLabel)
        writeButton.setAttributedTitle(ThemeText.tbvButton.attributedString(writeMessage), for: .normal)
        ThemeBorder.accent40.apply(writeButton)
        ThemeText.tbvHeader.apply(header, to: headerLabel)
        ThemeText.tbvVision.apply(message, to: detailLabel)
    }
}
