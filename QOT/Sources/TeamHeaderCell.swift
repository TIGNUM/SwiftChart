//
//  TeamHeaderCell.swift
//  QOT
//
//  Created by karmic on 26.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamHeaderCell: UICollectionViewCell {

    @IBOutlet weak var titleButton: UIButton!
    private var teamId = ""
    private var hexColorString = ""
    private var inviteCounter = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        titleButton.corner(radius: Layout.cornerRadius20, borderColor: .accent, borderWidth: 1)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeam,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeamColor,
                                               object: nil)
    }

    /// Configure Team
    func configure(teamId: String, title: String, hexColorString: String, selected: Bool) {
        self.teamId = teamId
        self.hexColorString = hexColorString
        titleButton.setTitle(title, for: .normal)
        setSelected(selected)
    }

    /// Configure Team Invitates
    func configure(title: String, counter: Int) {
        titleButton.setTitle(title, for: .normal)
        inviteCounter = counter
        setSelected(false)
    }
}

private extension TeamHeaderCell {
    @IBAction func didSelectTeam() {
        NotificationCenter.default.post(name: .didSelectTeam,
                                        object: nil,
                                        userInfo: [TeamHeader.Selector.teamId.rawValue: teamId])
    }

    @objc func checkSelection(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: String] else { return }
        if let teamId = userInfo[TeamHeader.Selector.teamId.rawValue] {
            setSelected(self.teamId == teamId)
        }
        if let teamColor = userInfo[TeamHeader.Selector.teamColor.rawValue] {
            hexColorString = teamColor
        }
    }

    func setSelected(_ selected: Bool) {
        if selected {
            titleButton.backgroundColor = UIColor(hex: hexColorString)
            titleButton.layer.borderColor = UIColor(hex: hexColorString).cgColor
            titleButton.setTitleColor(.sand, for: .normal)
        } else {
            titleButton.backgroundColor = .clear
            titleButton.layer.borderColor = UIColor(hex: hexColorString).cgColor
            titleButton.setTitleColor(UIColor(hex: hexColorString), for: .normal)
        }
    }
}
