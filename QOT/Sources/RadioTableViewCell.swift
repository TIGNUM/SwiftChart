//
//  RadioTableViewCell.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright © 2021 Tignum. All rights reserved.
//

import UIKit

class RadioTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet private weak var lableView: UIView!
    @IBOutlet private weak var radioStatusView: UIView!
    @IBOutlet private weak var bottomDivider: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var radioButton: UIButton!

    func configure(title: String?, subtitle: String?, onColor: UIColor, isOn: Bool) {
        titleLabel.text = title
        setSubtitle(subtitle)
    }
}

// MARK: - Private
private extension RadioTableViewCell {
    func setSubtitle(_ sub: String?) {
        subTitleLabel.isHidden = sub == nil
        subTitleLabel.text = sub
    }

    func setState(_ isOn: Bool) {
    }
}
