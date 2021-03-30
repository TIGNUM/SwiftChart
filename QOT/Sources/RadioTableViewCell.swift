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
    private var onColor: UIColor = .clear

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        radioButton.isSelected = selected
        titleLabel.textColor = selected ? onColor : .black
    }

    func configure(title: String?, subtitle: String?, onColor: UIColor) {
        titleLabel.text = title
        setSubtitle(subtitle)
        radioButton.setImage(R.image.ic_radio_on()?.withRenderingMode(.alwaysTemplate), for: .selected)
        radioButton.imageView?.tintColor = onColor
        self.onColor = onColor
    }
}

// MARK: - Private
private extension RadioTableViewCell {
    func setSubtitle(_ sub: String?) {
        subTitleLabel.isHidden = sub == nil
        subTitleLabel.text = sub
    }
}
