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
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var separatorView: UIView!

    func configure(title: String?, duration: String?) {
        ThemeText.resultTitle.apply(title?.uppercased(), to: titleLabel)
        ThemeText.resultDate.apply(duration, to: durationLabel)
        iconView.tintColor = .darkGray
        iconView.image = R.image.ic_seen_of()
    }
}
