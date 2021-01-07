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
    private var titleText: String?
    private var timeText: String?
    private var imageURL: URL?
    private var isSeen = false
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
        skeletonManager.addOtherView(seenCheckMark)
        previewPlayImageView.backgroundColor = UIColor.sand08
        previewPlayImageView.layer.cornerRadius = previewPlayImageView.frame.size.width / 2
        selectionStyle = .none
    }

    func configure(title: String?, timeToWatch: String?, imageURL: URL?, forcedColorMode: ThemeColorMode?, isSeen: Bool) {
        guard let titleText = title, let timeText = timeToWatch else { return }
        selectionStyle = .default
        self.isSeen = isSeen
        self.titleText = titleText
        self.timeText = timeText
        self.imageURL = imageURL
        ThemeText.articleRelatedTitle(forcedColorMode).apply(titleText, to: titleLabel)
        ThemeText.articleRelatedDetail(forcedColorMode).apply(timeText, to: detailLabel)
        previewImageView.setImage(url: imageURL, skeletonManager: self.skeletonManager) { (_) in /* */}
        mediaIconImageView.image = R.image.ic_camera_grey()
        colorMode == .dark ? ThemeTint.lightGrey.apply(mediaIconImageView) : ThemeTint.darkGrey.apply(mediaIconImageView)
        checkIfSeen(darkMode: forcedColorMode == .dark)
        skeletonManager.hide()
    }

    func setToSeen() {
        isSeen = true
    }
}

private extension FoundationTableViewCell {

    private func checkIfSeen(darkMode: Bool) {
        if isSeen {
            ThemeText.articleStrategyRead.apply(titleText, to: titleLabel)
            seenCheckMark.image?.withRenderingMode(.alwaysOriginal)
            ThemeTint.lightGrey.apply(seenCheckMark)
            seenCheckMark.isHidden = false
            setToBlackAndWhite(image: previewImageView.image)
        } else {
            let forcedMode: ThemeColorMode = darkMode ? .dark : .light
            ThemeText.articleRelatedTitle(forcedMode).apply(titleText, to: titleLabel)
            seenCheckMark.isHidden = true
        }
    }

    private func setToBlackAndWhite(image: UIImage?) {
        guard let originalImage = image, let ciImage = CIImage(image: originalImage) else { return }
        let grayscale = ciImage.applyingFilter("CIColorControls", parameters: [ kCIInputSaturationKey: 0.0 ])
        previewImageView.image = UIImage(ciImage: grayscale)
    }
}
