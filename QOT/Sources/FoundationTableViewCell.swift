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
    let skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .gray
        let bkView = UIView()
        ThemeView.level2Selected.apply(bkView)
        selectedBackgroundView = bkView
    }

    func configure(title: String, timeToWatch: String, imageURL: URL?, forcedColorMode: ThemeColorMode?) {
        ThemeText.articleRelatedTitle(forcedColorMode).apply(title, to: titleLabel)
        ThemeText.articleRelatedDetail(forcedColorMode).apply(timeToWatch, to: detailLabel)
        skeletonManager.addOtherView(previewImageView)
        previewImageView.kf.setImage(with: imageURL, placeholder: R.image.preloading(), options: nil, progressBlock: nil) { [weak self] (_) in
            self?.skeletonManager.hide()
        }
        previewPlayImageView.backgroundColor = UIColor.sand08
        previewPlayImageView.layer.cornerRadius = previewPlayImageView.frame.size.width / 2
        mediaIconImageView.image = R.image.ic_camera_sand()?.withRenderingMode(.alwaysTemplate)
        ThemeTint.accent.apply(mediaIconImageView)
    }
}
