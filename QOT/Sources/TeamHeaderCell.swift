//
//  TeamHeaderCell.swift
//  QOT
//
//  Created by karmic on 26.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

protocol TeamHeaderCellDelegate: class {
    func didSelectTeam(teamId: String)
}

final class TeamHeaderCell: UICollectionViewCell {

    @IBOutlet weak var titleButton: UIButton!
    weak var delegate: TeamHeaderCellDelegate?
    private var teamId: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        titleButton.corner(radius: Layout.cornerRadius20, borderColor: .accent, borderWidth: 1)
    }

    func configure(title: String, hexColorString: String, batchCount: Int, selected: Bool, teamId: String) {
        self.teamId = teamId
        titleButton.setTitle(title, for: .normal)
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

private extension TeamHeaderCell {
    @IBAction func didSelectTeam() {
        delegate?.didSelectTeam(teamId: teamId)
    }
}
