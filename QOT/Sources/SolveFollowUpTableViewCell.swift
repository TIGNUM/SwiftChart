//
//  SolveFollowUpTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 04.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol SolveFollowUpTableViewCellDelegate: class {
    func didTapFollowUp(isOn: Bool)
}

final class SolveFollowUpTableViewCell: DTResultBaseTableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var followUpSwitch: QotUISwitch!
    weak var delegate: SolveFollowUpTableViewCellDelegate?
}

// MARK: - Configuration

extension SolveFollowUpTableViewCell {

    func configure(title: String, description: String, isFollowUp: Bool = false) {
        selectionStyle = .none
        ThemeText.resultTitle.apply(title, to: titleLabel)
        ThemeText.resultFollowUp.apply(description, to: descriptionLabel)
        followUpSwitch.isOn = isFollowUp
    }
}

// MARK: - IBActions

extension SolveFollowUpTableViewCell {

    @IBAction func didTapFollowUp() {
        delegate?.didTapFollowUp(isOn: followUpSwitch.isOn)
    }
}
