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

final class SolveFollowUpTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var followUpSwitch: UISwitch!
    weak var delegate: SolveFollowUpTableViewCellDelegate?
}

// MARK: - Configuration

extension SolveFollowUpTableViewCell {

    func configure(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}

// MARK: - IBActions

extension SolveFollowUpTableViewCell {

    @IBAction func didTapFollowUp(_ sender: UISwitch) {
        delegate?.didTapFollowUp(isOn: followUpSwitch.isOn)
    }
}
