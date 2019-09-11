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
        ThemeText.coachHeader.apply(title.uppercased(), to: titleLabel)
        ThemeText.coachHeaderSubtitle.apply(subtitle, to: subtitleLabel)
    }
}
