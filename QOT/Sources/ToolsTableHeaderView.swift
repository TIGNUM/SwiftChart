//
//  ToolsTableHeaderView.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

import UIKit

final class ToolsTableHeaderView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    static func instantiateFromNib(title: String, subtitle: String) -> ToolsTableHeaderView {
        guard let headerView = R.nib.toolsTableHeaderView.instantiate(withOwner: self).first as? ToolsTableHeaderView else {
            fatalError("Cannot load header view")
        }
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        headerView.backgroundColor = .sand
        headerView.configure(title: title, subtitle: subtitle)
        return headerView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width
        subtitleLabel.preferredMaxLayoutWidth = subtitleLabel.bounds.width
    }

    func configure(title: String, subtitle: String) {
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                       letterSpacing: 0.2,
                                                       font: .apercuLight(ofSize: 30),
                                                       lineSpacing: 5,
                                                       textColor: .carbon,
                                                       alignment: .left)
        subtitleLabel.attributedText = NSAttributedString(string: subtitle,
                                                          letterSpacing: 0.3,
                                                          font: .apercuLight(ofSize: 16),
                                                          lineSpacing: 5,
                                                          textColor: .carbon,
                                                          alignment: .left)
    }
}
