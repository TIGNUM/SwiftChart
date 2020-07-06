//
//  TeamNameTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 01.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

class TeamNameTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var selectorLine: UIView!
    @IBOutlet weak var colorPickerView: UIView!
    var colorPicker: ColorPicker?
    weak var delegate: MyXTeamSettingsViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView = UIView(frame: self.bounds)
        ThemeView.level2Selected.apply(selectedBackgroundView!)
        selectorLine.isHidden = true

    }

    @IBAction func editTapped(_ sender: Any) {
        delegate?.presentEditTeam()
    }

    func configure(title: String, themeCell: ThemeView = .level2) {
        themeCell.apply(backgroundView!)
        colorPicker = R.nib.colorPicker.firstView(owner: self)
        colorPicker?.addTo(superview: colorPickerView)
        colorPicker?.delegate = delegate
        colorPicker?.configure(name: title)
    }
}
