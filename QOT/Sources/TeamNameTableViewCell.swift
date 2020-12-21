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
        backgroundView = UIView(frame: bounds)
        selectedBackgroundView = UIView(frame: bounds)
        NewThemeView.dark.apply(selectedBackgroundView!)
        NewThemeView.dark.apply(contentView)
        NewThemeView.dark.apply(self)
    }

    func configure(teamId: String,
                   teamColors: [String],
                   selectedColor: String,
                   title: String) {
        ThemeText.linkMenuItem.apply(title, to: nameLabel)
        nameLabel.text = title
        colorPicker.configure(teamId: teamId, teamColors: teamColors, selectedColor: UIColor(hex: selectedColor))
    }
}

// MARK: - Actions
private extension TeamNameTableViewCell {
    @IBAction func editTapped(_ sender: Any) {
        delegate?.presentEditTeam()
    }
}
