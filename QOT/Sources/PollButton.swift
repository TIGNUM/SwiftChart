//
//  PollButton.swift
//  QOT
//
//  Created by karmic on 04.09.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation

final class PollButton: SelectionButton {

    // MARK: - Properties
    @IBOutlet weak var pollTitleLabel: UILabel!
    @IBOutlet weak var counterLabelTop: UILabel!
    @IBOutlet weak var counterLabelBottom: UILabel!
    @IBOutlet weak var counterBackgroundView: UIView!
    @IBOutlet weak var counterContainerView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelTopWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelBottomWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundWidthConstraint: NSLayoutConstraint!
    private var votes = 0
    private var answerId = 0

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        counterBackgroundView.circle()
        counterBackgroundView.backgroundColor = .lightGray
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didVote(_:)),
                                               name: .didVoteTeamTBV, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didUnVote(_:)),
                                               name: .didUnVoteTeamTBV, object: nil)
    }

    // MARK: - Configure
    func configure(title: String, votes: Int, isSelected: Bool, answerId: Int) {
        self.votes = votes
        self.answerId = answerId
        super.configure(title: title, isSelected: isSelected)
        pollTitleLabel.attributedText = ThemeText.chatbotButton(isSelected).attributedString(title, alignment: .center)
        counterLabelTop.text = votes > 0 ? "\(votes)" : "\(votes + 1)"
        counterLabelBottom.text = "\(votes + 1)"
        backgroundWidthConstraint.constant = (votes == 0) ? 0 : 24
        labelTopWidthConstraint.constant = (votes == 0) ? 0 : 24
        labelBottomWidthConstraint.constant = (votes == 0) ? 0 : 24
        containerWidthConstraint.constant = (votes == 0) ? 0 : 24
    }
}

// MARK: - Oberserver
extension PollButton {
    @objc func didVote(_ notification: Notification) {
        if let answerId = notification.object as? Int, self.answerId == answerId {
            if votes > 0 {
                topConstraint.constant = topConstraint.constant - counterLabelTop.frame.height
            }
            backgroundWidthConstraint.constant = 24
            labelTopWidthConstraint.constant = 24
            labelBottomWidthConstraint.constant = 24
            containerWidthConstraint.constant = 24
            UIView.animate(withDuration: 0.6) {
                if self.votes > 0 {
                    self.counterLabelTop.alpha = 0
                    self.counterLabelBottom.alpha = 1
                    self.counterBackgroundView.alpha = 1
                    self.counterBackgroundView.backgroundColor = .lightGray
                }
                self.layoutIfNeeded()
            }
        }
    }

    @objc func didUnVote(_ notification: Notification) {
        if let answerId = notification.object as? Int, self.answerId == answerId {
            if votes > 0 {
                topConstraint.constant = topConstraint.constant + counterLabelTop.frame.height
            } else {
                backgroundWidthConstraint.constant = 0
                labelTopWidthConstraint.constant = 0
                labelBottomWidthConstraint.constant = 0
                containerWidthConstraint.constant = 0
            }
            UIView.animate(withDuration: 0.6) {
                if self.votes > 0 {
                    self.counterLabelTop.alpha = 1
                    self.counterLabelBottom.alpha = 0
                }
                self.layoutIfNeeded()
            }
        }
    }
}
