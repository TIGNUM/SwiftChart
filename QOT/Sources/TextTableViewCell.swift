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
    func configure(with text: String, textColor: UIColor?) {
        visionTextLabel.textColor = textColor
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.kern, value: 0.5, range: NSRange(location: 0, length: text.count))
        visionTextLabel.attributedText = attributedString
    }
}
