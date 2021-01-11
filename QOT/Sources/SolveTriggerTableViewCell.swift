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

final class SolveTriggerTableViewCell: DTResultBaseTableViewCell, Dequeueable {

    // MARK: - Properties
    weak var delegate: SolveTriggerTableViewCellDelegate?
    private var triggerType: SolveTriggerType = .midsetShifter
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var triggerDescription: UILabel!
    @IBOutlet private weak var startButton: AnimatedButton!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Configure
extension SolveTriggerTableViewCell {
    func configure(type: SolveTriggerType?, header: String, description: String, buttonText: String) {
        selectionStyle = .none
        ThemeView.resultWhite.apply(self)
        triggerType = type ?? .midsetShifter
        ThemeText.resultList.apply(header, to: headerLabel)
        ThemeText.resultHeader2.apply(description, to: triggerDescription)
        startButton.setTitle(buttonText, for: .normal)
        startButton.corner(radius: startButton.frame.height / 2)
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.borderWidth = 1.0
    }
}

// MARK: - IBActions
private extension SolveTriggerTableViewCell {
    @IBAction func didTapTriggerButton(_ sender: UIButton) {
        delegate?.didTapStart(triggerType)
    }
}
