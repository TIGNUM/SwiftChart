//
//  ResultsPrepareEventTableViewCell.swift
//  QOT
//
//  Created by karmic on 12.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class ResultsPrepareEventTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var dateIcon: UIImageView!
    weak var delegate: ResultsPrepareViewControllerInterface?

    override func awakeFromNib() {
        super.awakeFromNib()
        dateIcon.image = R.image.ic_event()?.withRenderingMode(.alwaysTemplate)
        dateIcon.tintColor = .carbon40
    }

    func configure(title: String, subtitle: String) {
        ThemeText.H02Light.apply(title, to: titleLabel)
        ThemeText.Text03Light.apply(subtitle, to: subtitleLabel)
    }
}

// MARK: - Actions
extension ResultsPrepareEventTableViewCell {
    @IBAction func didTapDelete() {
        delegate?.didTapDeleteEvent()
    }
}
