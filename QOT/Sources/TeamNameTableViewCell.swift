//
//  TeamNameTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 01.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

class TeamNameTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var pinkButton: UIButton!
    @IBOutlet weak var colourView: UIStackView!
    @IBOutlet weak var selectorLine: UIView!
    weak var delegate: MyXTeamSettingsViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView = UIView(frame: self.bounds)
        ThemeView.level2Selected.apply(selectedBackgroundView!)
        colourView.isHidden = true
        selectorLine.isHidden = true
    }

    @IBAction func editTapped(_ sender: Any) {
        delegate?.presentEditTeam()
    }

    func configure(title: String, themeCell: ThemeView = .level2) {
        themeCell.apply(backgroundView!)
        ThemeText.linkMenuItem.apply(title, to: nameLabel)
        nameLabel.text = title
    }
}
