//
//  TeamToBeVisionOptionTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation

final class TeamToBeVisionOptionTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ctaButton: RoundedButton!
    weak var delegate: TeamToBeVisionOptionsViewControllerDelegate?
    private var actionType: TeamToBeVisionOptionsViewController.ActionType = .rate

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIView(frame: bounds)
        self.selectedBackgroundView = UIView(frame: bounds)
        ThemeView.level2Selected.apply(selectedBackgroundView!)
    }

    func configure(title: String,
                   cta: String,
                   actionType: TeamToBeVisionOptionsViewController.ActionType,
                   buttonDisabled: Bool) {
        buttonDisabled ? ThemeText.optionPageDisabled.apply(title, to: titleLabel) : ThemeText.optionPage.apply(title, to: titleLabel)
        self.actionType = actionType
        ThemableButton.tbvOption(disabled: buttonDisabled).apply(ctaButton, title: cta)
        ctaButton.isUserInteractionEnabled = buttonDisabled == false
        ctaButton.corner(radius: 20, borderColor: .accent40)
    }

    @IBAction func ctaTapped(_ sender: Any) {
        switch actionType {
        case .rate:
            delegate?.showPoll()
        case .end:
            delegate?.showAlert()
        }
    }
}
