//
//  CoachTableHeaderView.swift
//  QOT
//
//  Created by Anais Plancoulaine on 06.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class CoachTableHeaderView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    static func instantiateFromNib(title: String, subtitle: String) -> CoachTableHeaderView {
        guard let headerView = R.nib.coachTableHeaderView.instantiate(withOwner: self).first as? CoachTableHeaderView else {
            fatalError("Cannot load header view")
        }
        headerView.backgroundColor = .sand
        headerView.configure(title: title, subtitle: subtitle)
        return headerView
    }

    func configure(title: String, subtitle: String) {
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                       letterSpacing: 0.2,
                                                       font: .apercuRegular(ofSize: 20),
                                                       lineSpacing: 8,
                                                       textColor: .carbon,
                                                       alignment: .left)
        subtitleLabel.attributedText = NSAttributedString(string: subtitle,
                                                       letterSpacing: 0.3,
                                                       font: .apercuRegular(ofSize: 12),
                                                       lineSpacing: 8,
                                                       textColor: .carbon,
                                                       alignment: .left)
    }
}
