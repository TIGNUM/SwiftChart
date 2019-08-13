//
//  SolveTriggerTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol SolveTriggerTableViewCellDelegate: class {
    func didTapStart(_ type: SolveTriggerType)
}

final class SolveTriggerTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    weak var delegate: SolveTriggerTableViewCellDelegate?
    private var triggerType: SolveTriggerType = .midsetShifter
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var triggerDescription: UILabel!
    @IBOutlet private weak var startButton: UIButton!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}

// MARK: - Configure
extension SolveTriggerTableViewCell {
    func configure(type: SolveTriggerType?, header: String, description: String, buttonText: String) {
        triggerType = type ?? .midsetShifter
        headerLabel.text = header
        triggerDescription.text = description
        startButton.setTitle(buttonText, for: .normal)
    }
}

// MARK: - IBActions
private extension SolveTriggerTableViewCell {
    @IBAction func didTapTriggerButton(_ sender: UIButton) {
        delegate?.didTapStart(triggerType)
    }
}

// MARK: - Private
private extension SolveTriggerTableViewCell {
    func setupView() {
        startButton.corner(radius: startButton.frame.height / 2)
        startButton.layer.borderColor = UIColor.accent.cgColor
        startButton.layer.borderWidth = 0.4
    }
}
