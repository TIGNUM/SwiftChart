//
//  ToolsTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class ToolsTableViewCell: BaseToolsTableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    // MARK: - Lifecycle

    func configure(title: String, subtitle: String) {
        ThemeText.qotTools.apply(title.uppercased(), to: titleLabel)
        ThemeText.qotToolsSectionSubtitle.apply(subtitle, to: subtitleLabel)
    }
}
