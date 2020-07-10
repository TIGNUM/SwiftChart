//
//  TeamMemberTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 10.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

class TeamMemberTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var joinedIcon: UIImageView!
    @IBOutlet private weak var pendingIcon: UIImageView!
    @IBOutlet private weak var emailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView = UIView(frame: self.bounds)
        ThemeView.level2Selected.apply(selectedBackgroundView!)
    }

    func configure(memberEmail: String?, memberStatus: MemberStatus) {
        ThemeText.memberEmail.apply(memberEmail, to: emailLabel)
        ThemeView.level2.apply(backgroundView!)
        pendingIcon.isHidden = memberStatus == .joined
        joinedIcon.isHidden = memberStatus == .pending
    }
}
