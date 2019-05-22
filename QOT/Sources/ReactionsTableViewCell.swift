//
//  ReactionsTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ReactionsTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var firstReactionLabel: UILabel!
    @IBOutlet private weak var secondReactionLabel: UILabel!
    @IBOutlet private weak var thirdReactionLabel: UILabel!
}

// MARK: - Configuration

extension ReactionsTableViewCell {

    func configure(title: String, reactions: [String]) {
        titleLabel.text = title
        firstReactionLabel.text = reactions[0]
        secondReactionLabel.text = reactions[1]
        thirdReactionLabel.text = reactions[2]
    }
}
