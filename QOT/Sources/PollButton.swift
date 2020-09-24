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
    @IBOutlet weak var counterLabelTop: UILabel!
    @IBOutlet weak var counterLabelBottom: UILabel!
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
        counterLabelTop.text = "\(votes)"
        counterLabelBottom.text = "\(votes + 1)"
        setHidden(votes == 0)
    }
}

// MARK: - Private
private extension PollButton {
    func setHidden(_ isHidden: Bool) {
        counterLabelTop.alpha = isHidden ? 0.3 : 1
        counterLabelBottom.alpha = isHidden ? 0 : 1
//        counterBackgroundView.alpha = isHidden ? 0 : 1
    }
}

// MARK: - Oberserver
extension PollButton {
    @objc func didVote(_ notification: Notification) {
        if let answerId = notification.object as? Int, self.answerId == answerId {
            let yPointTop = counterLabelTop.frame.origin.y
            let yPointBottom = counterLabelBottom.frame.origin.y
            let xPoint = counterLabelTop.frame.origin.x
            let height = counterLabelTop.frame.height
            UIView.animate(withDuration: 0.6) {
                self.counterLabelTop.alpha = 0
                self.counterLabelBottom.alpha = 1
                self.counterLabelTop.frame.origin = CGPoint(x: xPoint, y: yPointTop - height)
                self.counterLabelBottom.frame.origin = CGPoint(x: xPoint, y: yPointBottom - height)
            }
        }
    }

    @objc func didUnVote(_ notification: Notification) {
        if let answerId = notification.object as? Int, self.answerId == answerId {
            let yPointTop = counterLabelTop.frame.origin.y
            let yPointBottom = counterLabelBottom.frame.origin.y
            let xPoint = counterLabelTop.frame.origin.x
            let height = counterLabelTop.frame.height
            UIView.animate(withDuration: 0.6) {
                self.counterLabelTop.alpha = 1
                self.counterLabelBottom.alpha = 0
                self.setHidden(self.votes == 0)
                self.counterLabelTop.frame.origin = CGPoint(x: xPoint, y: yPointTop + height)
                self.counterLabelBottom.frame.origin = CGPoint(x: xPoint, y: yPointBottom + height)
            }
        }
    }
}
