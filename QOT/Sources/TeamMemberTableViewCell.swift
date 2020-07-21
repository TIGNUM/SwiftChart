//
//  TeamMemberTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 10.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamMemberTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var joinedIcon: UIImageView!
    @IBOutlet private weak var pendingIcon: UIImageView!
    @IBOutlet private weak var emailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIView(frame: bounds)
        self.selectedBackgroundView = UIView(frame: bounds)
        ThemeView.level2Selected.apply(selectedBackgroundView!)
    }

    func configure(memberEmail: String?, memberStatus: TeamMember.Status) {
        ThemeText.memberEmail.apply(memberEmail, to: emailLabel)
        ThemeView.level2.apply(backgroundView!)
        pendingIcon.isHidden = memberStatus == .joined
        joinedIcon.isHidden = memberStatus == .pending
    }
}
