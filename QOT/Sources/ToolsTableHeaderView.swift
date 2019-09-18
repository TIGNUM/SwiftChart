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
        ThemeText.qotToolsTitle.apply(title.uppercased(), to: titleLabel)
        ThemeText.qotToolsSubtitle.apply(subtitle, to: subtitleLabel)
        subtitle == "" ? (subtitleLabel.isHidden = true) : (subtitleLabel.isHidden = false)
    }
}
