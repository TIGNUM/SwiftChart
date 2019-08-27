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
    @IBOutlet private weak var previewPlayImageView: UIImageView!
    @IBOutlet private weak var mediaIconImageView: UIImageView!

    func configure(title: String, timeToWatch: String, imageURL: URL?, alwaysDark: Bool = false) {
        let requiredMode: ColorMode = alwaysDark ? ColorMode.dark : colorMode

        let editedTitle = title.replacingOccurrences(of: "PERFORMANCE ", with: "")

        ThemeText.articleRelatedTitle.apply(editedTitle, to: titleLabel)
        ThemeText.articleRelatedDetail.apply(timeToWatch, to: detailLabel)
        previewImageView.kf.setImage(with: imageURL, placeholder: R.image.preloading())
        previewPlayImageView.backgroundColor = UIColor.sand08
        previewPlayImageView.layer.cornerRadius = previewPlayImageView.frame.size.width / 2
        mediaIconImageView.image = R.image.ic_camera_sand()?.withRenderingMode(.alwaysTemplate)
        mediaIconImageView.tintColor = requiredMode.tint
        contentView.backgroundColor = requiredMode.background
    }
}
