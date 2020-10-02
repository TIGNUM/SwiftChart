//
//  TeamToBeVisionOptionTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TeamToBeVisionOptionTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ctaButton: RoundedButton!
    weak var delegate: TeamToBeVisionOptionsViewControllerDelegate?
    private var actionTag: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView = UIView(frame: self.bounds)
        ThemeView.level2Selected.apply(selectedBackgroundView!)
    }

    func configure(title: String, cta: String, actionTag: Int, buttonDisabled: Bool) {
        buttonDisabled ? ThemeText.optionPageDisabled.apply(title, to: titleLabel) : ThemeText.optionPage.apply(title, to: titleLabel)
        self.actionTag = actionTag
        ThemableButton.tbvOption(disabled: buttonDisabled).apply(ctaButton, title: cta)
    }

    @IBAction func ctaTapped(_ sender: Any) {
        switch actionTag {
        case TeamToBeVisionOptionsViewController.actionType.rate.rawValue:
            delegate?.didTapRateOrVote()
        case TeamToBeVisionOptionsViewController.actionType.end.rawValue:
            delegate?.showAlert()
        default:
            break
        }
    }
}
