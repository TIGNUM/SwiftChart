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
    @IBOutlet private weak var seenCheckMark: UIImageView!
    private var isSeen: Bool?
    private var titleText: String?
    private var timeText: String?
    private var imageURL: URL?
    let skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .gray
        let bkView = UIView()
        ThemeView.level2Selected.apply(bkView)
        selectedBackgroundView = bkView
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(detailLabel)
        skeletonManager.addOtherView(previewImageView)
        skeletonManager.addOtherView(mediaIconImageView)
        selectionStyle = .none
//        checkIfSeen()
    }

    func configure(title: String?, timeToWatch: String?, imageURL: URL?, forcedColorMode: ThemeColorMode?, isSeen: Bool?) {
        guard let titleText = title, let timeText = timeToWatch else { return }
        selectionStyle = .default
        skeletonManager.hide()
        self.isSeen = isSeen
        self.titleText = titleText
        self.timeText = timeText
        self.imageURL = imageURL
        ThemeText.articleRelatedTitle(forcedColorMode).apply(titleText, to: titleLabel)
        ThemeText.articleRelatedDetail(forcedColorMode).apply(timeText, to: detailLabel)
        skeletonManager.addOtherView(previewImageView)
        previewImageView.setImage(url: imageURL, skeletonManager: self.skeletonManager) { (_) in /* */}
        previewPlayImageView.backgroundColor = UIColor.sand08
        previewPlayImageView.layer.cornerRadius = previewPlayImageView.frame.size.width / 2
        mediaIconImageView.image = R.image.ic_camera_sand()?.withRenderingMode(.alwaysTemplate)
        ThemeTint.accent.apply(mediaIconImageView)
        checkIfSeen()
    }

//    do we have to watch the videos until the end for it to be watched?
    private func checkIfSeen() {
        if let isSeen = isSeen {
            if isSeen {
                ThemeText.articleStrategyRead.apply(titleText, to: titleLabel)
                seenCheckMark.fadeIn()
                let image = previewImageView.image
                previewImageView.image = image?.noir
            } else {
                ThemeText.articleStrategyTitle.apply(titleText, to: titleLabel)
                seenCheckMark.alpha = 0
            }
        }
    }
}
