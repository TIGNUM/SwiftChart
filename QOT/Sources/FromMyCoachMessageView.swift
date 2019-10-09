//
//  FromMyCoachMessageView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 05.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class FromMyCoachMessageView: UIView {

    var isFirstView: Bool = false

    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var topSeparatorView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var topViewHeightConstraint: NSLayoutConstraint!

    enum Spacing: CGFloat {
        case defaultSpacing = 0
        case fromSecondViewSpacing = 30
    }

    static func instantiateFromNib() -> FromMyCoachMessageView? {
        guard let fromMyCoachMessageView = R.nib.fromMyCoachMessageView.instantiate(withOwner: self).first as? FromMyCoachMessageView else {
            log("Cannot load view: (self.Type)", level: .error)
            return nil
        }
        return fromMyCoachMessageView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirstView {
            containerView.maskCorners(corners: [.bottomLeft, .bottomRight], radius: Layout.cornerRadius08)
        } else {
            containerView.corner(radius: Layout.cornerRadius08)
        }
    }

    func configure(with data: FromMyCoachCellViewModel.FromMyCoachMessage) {
        topViewHeightConstraint.constant = isFirstView == true ? Spacing.defaultSpacing.rawValue : Spacing.fromSecondViewSpacing.rawValue
        topSeparatorView.isHidden = isFirstView == true
        ThemeView.level1.apply(self)
        ThemeText.performanceSubtitle.apply(data.date, to: dateLabel)
        ThemeText.performanceSectionText.apply(data.text, to: textLabel)
    }
}
