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
    @IBOutlet weak var titeLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var counterBackgroundView: UIView!
    private var votes = 0
    private var answerId = 0

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        counterBackgroundView.circle()
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
        counterLabel.text = "\(votes - 1)" + "\n" + "\(votes)" + "\n" + "\(votes + 1)"
    }
}

// MARK: - Oberserver
extension PollButton {
    @objc func didVote(_ notification: Notification) {
        if let answerId = notification.object as? Int, self.answerId == answerId {
            let yPoint = counterLabel.frame.origin.y
            let xPoint = counterLabel.frame.origin.x
            let height = counterLabel.frame.height
            UIView.animate(withDuration: 0.6) {
                self.counterLabel.frame.origin = CGPoint(x: xPoint, y: yPoint - height)
            }
        }
    }

    @objc func didUnVote(_ notification: Notification) {
        if let answerId = notification.object as? Int, self.answerId == answerId {
            let yPoint = counterLabel.frame.origin.y
            let xPoint = counterLabel.frame.origin.x
            let height = counterLabel.frame.height
            UIView.animate(withDuration: 0.6) {
                self.counterLabel.frame.origin = CGPoint(x: xPoint, y: yPoint + height)
            }
        }
    }
}
