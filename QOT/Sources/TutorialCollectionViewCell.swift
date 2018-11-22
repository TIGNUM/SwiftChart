//
//  TutorialCollectionViewCell.swift
//  QOT
//
//  Created by karmic on 16.11.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class TutorialCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        subtitleLabel.attributedText = nil
        bodyLabel.attributedText = nil
        imageView.image = nil
    }

    func configure(title: String?, subtitle: String?, body: String?, imageURL: URL?) {
        titleLabel.attributedText = attributedString(string: title, itemType: .title)
        subtitleLabel.attributedText = attributedString(string: subtitle, itemType: .subtitle)
        bodyLabel.attributedText = attributedString(string: body, itemType: .body)
        imageView.kf.setImage(with: imageURL)
    }
}

// MARK: - Private

private extension TutorialCollectionViewCell {

    func attributedString(string: String?, itemType: TutorialModel.ItemType) -> NSAttributedString {
        return NSAttributedString(string: string ?? "",
                                  letterSpacing: 1,
                                  font: itemType.font,
                                  lineSpacing: 6,
                                  textColor: .white,
                                  alignment: .center,
                                  lineBreakMode: .byWordWrapping)
    }
}
