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
    func configure(with question: String?, html: String?, questionUpdate: String?, textColor: UIColor) {
        var updatedTitle: String
        var attributedString = NSMutableAttributedString()
        if let html = html {
            updatedTitle = updateQuestionIfNeeded(html, questionUpdate)
            attributedString = NSMutableAttributedString(attributedString: updatedTitle.convertHtml() ?? NSAttributedString())
        } else if let question = question {
            updatedTitle = updateQuestionIfNeeded(question, questionUpdate)
            attributedString = NSMutableAttributedString(string: updatedTitle)
        }
        let paragraphStyle = NSMutableParagraphStyle()
        let range = NSRange(location: 0, length: attributedString.length)
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        questionLabel.attributedText = attributedString
    }
}

private extension QuestionTableViewCell {
    func updateQuestionIfNeeded(_ question: String, _ toUpdate: String?) -> String {
        guard let update = toUpdate, update.isEmpty == false else { return question }
        if update == AnswerKey.Recovery.general.rawValue {
            return update
        }
        if question.contains("${sprintName}") {
            return question.replacingOccurrences(of: "${sprintName}", with: update)
        }
        return question.replacingOccurrences(of: "%@", with: update)
    }
}
