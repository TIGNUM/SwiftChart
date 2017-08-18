//
//  ImageSubtitleTableViewCell.swift
//  QOT
//
//  Created by tignum on 5/2/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ImageSubtitleTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Outlets

    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var playImageView: UIImageView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    func setInsets(insets: UIEdgeInsets, spacing: CGFloat = 12) {
        topConstraint.constant = insets.top
        leadingConstraint.constant = insets.left
        trailingConstraint.constant = insets.right
        bottomConstraint.constant = insets.bottom        
    }

    func setupData(placeHolder: URL, placeHolderImage: UIImage? = nil, description: NSAttributedString?, canStream: Bool) {
        label.isHidden = (description == nil)
        label.attributedText = description
        mainImageView.kf.setImage(with: placeHolder, placeholder: placeHolderImage, options: nil, progressBlock: nil, completionHandler: nil)
        mainImageView.kf.indicatorType = .activity
        mainImageView.contentMode = .scaleAspectFill
        playImageView.isHidden = canStream == false
        playImageView.image = R.image.ic_play_video()
    }
}
