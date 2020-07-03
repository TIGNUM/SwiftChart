//
//  TeamNameTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 01.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamNameTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var colorPicker: ColorPicker!
    weak var delegate: MyXTeamSettingsViewController?

    // MARK: - Liefe cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView = UIView(frame: self.bounds)
        ThemeView.level2Selected.apply(selectedBackgroundView!)
    }

    func configure(teamId: String, teamColor: String, title: String, themeCell: ThemeView = .level2) {
        themeCell.apply(backgroundView!)
        ThemeText.linkMenuItem.apply(title, to: nameLabel)
        nameLabel.text = title
        colorPicker.configure(teamId: teamId, teamColor: UIColor(hex: teamColor))
    }
}

// MARK: - Actions
private extension TeamNameTableViewCell {
    @IBAction func editTapped(_ sender: Any) {
        delegate?.presentEditTeam()
    }
}
