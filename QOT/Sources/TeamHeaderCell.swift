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
    @IBOutlet private weak var counterLabel: UILabel!
    private var teamId = ""
    private var hexColorString = ""
    private var inviteCounter = 0
    private var itemSelected = false
    private var canDeselect = true
    private var teamInvites: [QDMTeamInvitation] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        counterLabel.circle()
        counterLabel.isHidden = true
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

    override func prepareForReuse() {
        super.prepareForReuse()
        itemButton.setTitle(nil, for: .normal)
        teamInvites.removeAll()
    }

    func configure(teamId: String,
                   title: String,
                   hexColorString: String,
                   selected: Bool,
                   canDeselect: Bool,
                   newCount: Int = 0) {
        self.teamInvites.removeAll()
        self.counterLabel.isHidden = newCount == 0
        self.counterLabel.text = nil
        self.teamId = teamId
        self.hexColorString = hexColorString
        self.itemSelected = selected
        self.canDeselect = canDeselect
        itemButton.setTitle(title, for: .normal)
        setSelected(selected)
    }

    func configure(teamInvites: [QDMTeamInvitation]) {
        self.counterLabel.isHidden = !(teamInvites.isEmpty)
        self.counterLabel.text = String(teamInvites.count)
        self.teamInvites = teamInvites
        self.canDeselect = false
        self.teamId = ""
        self.counterLabel.isHidden = teamInvites.count == 0
        self.counterLabel.text = "\(teamInvites.count)"
        itemButton.setTitle(AppTextService.get(.my_x_team_invite_cta), for: .normal)
        itemButton.backgroundColor = .carbon
        itemButton.layer.borderColor = UIColor.accent40.cgColor
        itemButton.setTitleColor(.accent, for: .normal)
        setSelected(false)
    }
}

private extension TeamHeaderCell {
    @IBAction func didSelectTeam() {
        if teamInvites.isEmpty {
            if !itemSelected || itemSelected && canDeselect {
                NotificationCenter.default.post(name: .didSelectTeam,
                                                object: nil,
                                                userInfo: [Team.KeyTeamId: teamId])
            }
        } else {
            NotificationCenter.default.post(name: .didSelectTeamInvite,
                                            object: nil,
                                            userInfo: nil)
        }
    }

    @objc func checkSelection(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: String] else { return }
        if userInfo.keys.contains(Team.KeyTeamId), let teamId = userInfo[Team.KeyTeamId] {
            itemSelected = self.teamId == teamId && !itemSelected
            setSelected(itemSelected)
            log("teamId: " + teamId, level: .debug)
        }
        if itemSelected && userInfo.keys.contains(Team.KeyColor), let teamColor = userInfo[Team.KeyColor] {
            hexColorString = teamColor
            setSelected(itemSelected)
        }
    }

    func setSelected(_ selected: Bool) {
        guard teamInvites.isEmpty else { return }
        itemButton.layer.borderColor = UIColor(hex: hexColorString).withAlphaComponent(0.4).cgColor
        if selected {
            itemButton.backgroundColor = UIColor(hex: hexColorString)
            itemButton.setTitleColor(.sand, for: .normal)
        } else {
            itemButton.backgroundColor = .clear
            itemButton.setTitleColor(UIColor(hex: hexColorString), for: .normal)
        }
    }
}
