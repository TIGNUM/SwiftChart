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
    @IBOutlet private weak var contentView: UIView!
    private var timer: Timer?
    private var isEnabled: Bool = true

    static var shared: NotificationBanner = {
        guard let headerView = R.nib.notificationBanner.instantiate(withOwner: self).first as? NotificationBanner else {
            fatalError("Cannot load NotificationBanner view")
        }
        headerView.contentView.corner(radius: 8)
        return headerView
    }()

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    func configure(message: String, isDark: Bool) {
        if isDark {
            ThemeView.level1.apply(contentView)
            ThemeText.darkBanner.apply(message, to: titleLabel)
        } else {
            ThemeView.whiteBanner.apply(contentView)
            ThemeText.whiteBanner.apply(message, to: titleLabel)
        }
    }

    func show(in view: UIView) {
        if isEnabled {
            isEnabled.toggle()
            let frame = self.frame
            self.frame = CGRect(x: 0,
                                y: frame.origin.y + frame.height,
                                width: UIScreen.main.bounds.width,
                                height: frame.height)
            self.alpha = 0
            view.addSubview(self)
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 1 }, completion: { (_) in
                self.startTimer()
            })
        }
    }
}

// MARK: - Private
private extension NotificationBanner {
    func hide() {
        timer?.invalidate()
        timer = nil
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }, completion: { (_) in
            self.isEnabled.toggle()
            self.alpha = 0
            self.removeFromSuperview()
        })
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            self.hide()
        }
    }
}
