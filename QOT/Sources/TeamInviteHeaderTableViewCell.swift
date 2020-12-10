//
//  TeamInviteHeaderTableViewCell.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamInviteHeaderTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var teamCountLabel: UILabel!
    @IBOutlet private weak var noteLabel: UILabel!
    private lazy var skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        NewThemeView.dark.apply(self)
        noteLabel.isHidden = true
        teamCountLabel.isHidden = true
        skeletonManager.addTitle(headerLabel)
        skeletonManager.addSubtitle(contentLabel)
        skeletonManager.addSubtitle(teamCountLabel)
        skeletonManager.addSubtitle(noteLabel)
    }

    func configure(header: String?, content: String?, teamCount: String?, note: String?) {
        noteLabel.isHidden = note == nil
        teamCountLabel.isHidden = teamCount == nil
        skeletonManager.hide()
        ThemeText.myQOTPrepTitle.apply(header, to: headerLabel)
        ThemeText.tbvCustomizeBody.apply(content, to: contentLabel)
        ThemeText.registrationCodeDescriptionEmail.apply(teamCount, to: teamCountLabel)
        ThemeText.tbvCustomizeBody.apply(note, to: noteLabel)
    }
}
