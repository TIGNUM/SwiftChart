//
//  ArticleRelatedCell.swift
//  QOT
//
//  Created by karmic on 23.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

final class ArticleRelatedCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    let skeletonManager = SkeletonManager()

    // MARK: - Initialisers

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }

    private func setupCell() {
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = UIColor.black15
        self.selectedBackgroundView = selectedBackground
    }

    // MARK: - Setup

    func setupView(title: String, subTitle: String, previewImageURL: URL?) {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        skeletonManager.addOtherView(previewImageView)
        previewImageView.setImage(url: previewImageURL,
                                  skeletonManager: self.skeletonManager) { (_) in /* */}
        previewImageView.layer.cornerRadius = 8
        previewImageView.layer.masksToBounds = true
        titleLabel.attributedText = Style.headline(title.uppercased()).attributedString()
        subTitleLabel.attributedText = NSMutableAttributedString(string: subTitle.uppercased(),
                                                                 letterSpacing: 2,
                                                                 font: .H7Title,
                                                                 textColor: .whiteLight40)
    }
}
