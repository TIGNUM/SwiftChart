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
    func configure(with question: String, questionTitleUpdate: String?) {
        let tempQuestion = updateQuestionIfNeeded(question, questionTitleUpdate)
        let attributedString = NSMutableAttributedString(string: tempQuestion)
        let paragraphStyle = NSMutableParagraphStyle()
        let range = NSRange(location: 0, length: attributedString.length)
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        questionLabel.attributedText = attributedString
    }
}

private extension QuestionTableViewCell {
    func updateQuestionIfNeeded(_ question: String, _ questionTitleUpdate: String?) -> String {
        guard let update = questionTitleUpdate else { return question }
        if update == AnswerKey.Recovery.general.rawValue {
            return update
        }
        return question.replacingOccurrences(of: "%@", with: update)
    }
}
