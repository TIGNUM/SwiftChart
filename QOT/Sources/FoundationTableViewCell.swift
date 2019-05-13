//
//  FoundationTableViewCell.swift
//  QOT
//
//  Created by karmic on 19.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class FoundationTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var mediaIconImageView: UIImageView!

    func configure(title: String, timeToWatch: String, imageURL: URL?) {
        let editedTitle = title.replacingOccurrences(of: "PERFORMANCE ", with: "")
        titleLabel.attributedText = NSAttributedString(string: editedTitle,
                                                       letterSpacing: 0.5,
                                                       font: .apercuLight(ofSize: 16),
                                                       lineSpacing: 8,
                                                       textColor: colorMode.text,
                                                       alignment: .left)
        detailLabel.attributedText = NSAttributedString(string: timeToWatch,
                                                        letterSpacing: 0.4,
                                                        font: .apercuMedium(ofSize: 12),
                                                        textColor: colorMode.text.withAlphaComponent(0.3),
                                                        alignment: .left)
        previewImageView.kf.setImage(with: imageURL, placeholder: R.image.preloading())
        mediaIconImageView.image = R.image.ic_camera_sand()?.withRenderingMode(.alwaysTemplate)
        mediaIconImageView.tintColor = colorMode.tint
        contentView.backgroundColor = colorMode.background
    }
}
