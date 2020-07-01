//
//  TeamHeaderCell.swift
//  QOT
//
//  Created by karmic on 26.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamHeaderCell: UICollectionViewCell {

    @IBOutlet weak var titleButton: UIButton!
    private var teamId = ""
    private var hexColorString = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        titleButton.corner(radius: Layout.cornerRadius20, borderColor: .accent, borderWidth: 1)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeam, object: nil)
    }

    func configure(title: String, hexColorString: String, batchCount: Int, selected: Bool, teamId: String) {
        self.teamId = teamId
        self.hexColorString = hexColorString
        titleButton.setTitle(title, for: .normal)
        setSelected(selected)
    }
}

private extension TeamHeaderCell {
    @IBAction func didSelectTeam() {
        NotificationCenter.default.post(name: .didSelectTeam, object: teamId)
    }

    @objc func checkSelection(_ notification: Notification) {
        guard let teamId = notification.object as? String else { return }
        setSelected(self.teamId == teamId)
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
