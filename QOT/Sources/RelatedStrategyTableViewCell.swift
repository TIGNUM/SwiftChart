//
//  RelatedStrategyTableViewCell.swift
//  QOT
//
//  Created by karmic on 04.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class RelatedStrategyTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!

    func configure(title: String?, duration: String?) {
        ThemeText.resultTitle.apply(title, to: titleLabel)
        ThemeText.resultDate.apply(duration, to: durationLabel)
    }
}
