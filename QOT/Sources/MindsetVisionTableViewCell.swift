//
//  MindsetVisionTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MindsetVisionTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var visionLabel: UILabel!
}

// MARK: - Configuration

extension MindsetVisionTableViewCell {

    func configure(title: String, vision: String) {
        titleLabel.text = title
        visionLabel.text = vision
        updateConstraintsIfNeeded()
    }
}
