//
//  CoachTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 06.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class CoachTableViewCell: BaseToolsTableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    // MARK: - Lifecycle

    func configure(title: String, subtitle: String) {
        ThemeText.coachTitle.apply(title.uppercased(), to: titleLabel)
        ThemeText.coachSubtitle.apply(subtitle, to: subtitleLabel)
    }
}
