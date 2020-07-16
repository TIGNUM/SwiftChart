//
//  TeamHeaderCell.swift
//  QOT
//
//  Created by karmic on 26.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamHeaderCell: UICollectionViewCell, Dequeueable {

    @IBOutlet private weak var itemButton: UIButton!
    private var teamId = ""
    private var hexColorString = ""
    private var inviteCounter = 0
    private var teamInvites: [QDMTeamInvitation] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        itemButton.corner(radius: Layout.cornerRadius20, borderColor: .accent, borderWidth: 1)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeam,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeamColor,
                                               object: nil)
    }

    func configure(teamId: String, title: String, hexColorString: String, selected: Bool) {
        self.teamId = teamId
        self.hexColorString = hexColorString
        itemButton.setTitle(title, for: .normal)
        setSelected(selected)
    }

    func configure(teamInvites: [QDMTeamInvitation]) {
        self.teamInvites = teamInvites
        itemButton.setTitle(AppTextService.get(.my_x_team_invite_cta), for: .normal)
        itemButton.backgroundColor = .carbon
        itemButton.layer.borderColor = UIColor.accent.cgColor
        itemButton.setTitleColor(.accent, for: .normal)
    }
}

private extension TeamHeaderCell {
    @IBAction func didSelectTeam() {
        if teamInvites.isEmpty {
            NotificationCenter.default.post(name: .didSelectTeam,
                                            object: nil,
                                            userInfo: [Team.KeyTeamId: teamId])
        } else {
            NotificationCenter.default.post(name: .didSelectTeamInvite,
                                            object: nil,
                                            userInfo: nil)
        }
    }

    @objc func checkSelection(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: String] else { return }
        if let teamId = userInfo[Team.KeyTeamId] {
            setSelected(self.teamId == teamId)
        }
        if let teamColor = userInfo[Team.KeyColor] {
            hexColorString = teamColor
        }
    }

    func setSelected(_ selected: Bool) {
        if selected {
            itemButton.backgroundColor = UIColor(hex: hexColorString)
            itemButton.layer.borderColor = UIColor(hex: hexColorString).cgColor
            itemButton.setTitleColor(.sand, for: .normal)
        } else {
            itemButton.backgroundColor = .clear
            itemButton.layer.borderColor = UIColor(hex: hexColorString).cgColor
            itemButton.setTitleColor(UIColor(hex: hexColorString), for: .normal)
        }
    }
}
