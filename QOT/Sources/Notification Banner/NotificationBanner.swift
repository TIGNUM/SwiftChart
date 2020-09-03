//
//  NotificationBanner.swift
//  QOT
//
//  Created by karmic on 26.08.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class NotificationBanner: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var contentView: UIView!
    private var timer: Timer?

    static func instantiateFromNib() -> NotificationBanner {
        guard let headerView = R.nib.notificationBanner.instantiate(withOwner: self).first as? NotificationBanner else {
            fatalError("Cannot load NotificationBanner view")
        }
        headerView.contentView.corner(radius: 8)
        return headerView
    }

    func configure(message: String) {
        titleLabel.text = message
    }

    func show(in view: UIView) {
        let frame = self.frame
        view.addSubview(self)

        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(x: 0,
                                y: frame.origin.y + 10 + frame.height,
                                width: frame.width,
                                height: frame.height)
        }) { (_) in
            self.startTimer()
        }
    }
}

// MARK: - Actions
extension NotificationBanner {
    @IBAction func didTapClose() {
        hide()
    }
}

// MARK: - Private
private extension NotificationBanner {
    func hide() {
        timer?.invalidate()
        timer = nil

        UIView.animate(withDuration: 0.3) {
            self.frame = CGRect(x: 0,
                                y: self.frame.origin.y - (self.frame.height + 20),
                                width: self.frame.width,
                                height: self.frame.height)
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            self.hide()
        }
    }
}
