//
//  QuestionTableViewCell.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 12.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class QuestionTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet weak var questionLabel: UILabel!
}

// MARK: Configuration

extension QuestionTableViewCell {

    func configure(with question: String) {
        let attributedString = NSMutableAttributedString(string: question)
        let paragraphStyle = NSMutableParagraphStyle()
        let range = NSRange(location: 0, length: attributedString.length)
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        questionLabel.attributedText = attributedString
    }
}
