//
//  AnimatedAnswerTableViewCell.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 10/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol AnimatedAnswerCellDelegate: class {
    func didFinishTypeAnimation()
}

final class AnimatedAnswerTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    weak var delegate: AnimatedAnswerCellDelegate?
    @IBOutlet weak var answerLabel: UILabel!
    private var typingAnimation: DotsLoadingView?
    private var textToDisplay: NSAttributedString?

    override func prepareForReuse() {
        super.prepareForReuse()
        typingAnimation = nil
        delegate = nil
        typingAnimation?.removeFromSuperview()
    }
}

// MARK: Configuration
extension AnimatedAnswerTableViewCell {
    func configure(with question: String?, html: String?, questionUpdate: String?, textColor: UIColor, animateTextDuration: Double = 0.0) {
        var updatedTitle: String
        var attributedString = NSMutableAttributedString()
        if let html = html {
            updatedTitle = updateTextIfNeeded(html, questionUpdate)
            attributedString = NSMutableAttributedString(attributedString: updatedTitle.convertHtml() ?? NSAttributedString())
        } else if let question = question {
            updatedTitle = updateTextIfNeeded(question, questionUpdate)
            attributedString = NSMutableAttributedString(string: updatedTitle)
        }
        let paragraphStyle = NSMutableParagraphStyle()
        let range = NSRange(location: 0, length: attributedString.length)
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        answerLabel.attributedText = attributedString

        if animateTextDuration > 0 {
            let dots = DotsLoadingView(frame: CGRect(x: 24, y: 0, width: 20, height: .TypingFooter))
            dots.configure(dotsColor: textColor)
            dots.translatesAutoresizingMaskIntoConstraints = false
            addSubview(dots)
            dots.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
            dots.widthAnchor.constraint(equalToConstant: 20).isActive = true
            dots.heightAnchor.constraint(equalToConstant: .TypingFooter).isActive = true
            dots.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            typingAnimation = dots

            typingAnimationStart()
            textToDisplay = answerLabel.attributedText
            answerLabel.text = ""
        }
    }
}

private extension AnimatedAnswerTableViewCell {
    func updateTextIfNeeded(_ text: String, _ toUpdate: String?) -> String {
        guard let update = toUpdate, update.isEmpty == false else { return text }
        if update == AnswerKey.Recovery.general.rawValue {
            return update
        }
        if text.contains("${sprintName}") {
            return text.replacingOccurrences(of: "${sprintName}", with: update)
        }
        return text.replacingOccurrences(of: "%@", with: update)
    }
}

// MARK: Animation
extension AnimatedAnswerTableViewCell {
    func typingAnimationStart() {
        guard let typingAnimation = typingAnimation else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + Animation.duration_3) { [weak self] in
            UIView.animate(withDuration: Animation.duration_06, animations: {
                typingAnimation.alpha = 1.0
            })

            typingAnimation.startAnimation(withDuration: Animation.duration_3) {
                self?.answerLabel.attributedText = self?.textToDisplay
                self?.delegate?.didFinishTypeAnimation()
                self?.delegate = nil
            }
        }
    }
}
