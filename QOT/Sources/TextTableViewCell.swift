//
//  TextTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 12.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class TextTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    @IBOutlet private weak var visionTextLabel: UILabel!
}

// MARK: - Configuration
extension TextTableViewCell {
    func configure(with text: String) {
        visionTextLabel.text = text
        visionTextLabel.addCharacterSpacing(0.5)
    }
}
