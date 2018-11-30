//
//  ArticleItemHeaderView.swift
//  QOT
//
//  Created by karmic on 23.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

final class ArticleItemHeaderView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
	@IBOutlet private weak var articleThumbnail: UIImageView!
    @IBOutlet private var titleTopContraint: NSLayoutConstraint!

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yy")
        dateFormatter.locale = .current
        return dateFormatter
    }()

    func setupView(header: ArticleCollectionHeader, pageName: PageName) {
		let duration = header.articleDuration.uppercased() == "0 MIN" ? "1 MIN" : header.articleDuration.uppercased()
		titleLabel.attributedText = attributedText(letterSpacing: 1,
												   text: header.articleTitle.uppercased(),
												   font: .H5SecondaryHeadline,
												   textColor: .white,
												   alignment: .left)
		subTitleLabel.attributedText = attributedText(text: header.articleSubTitle.uppercased(),
													  font: .H1MainTitle,
													  textColor: .white,
													  alignment: .left)
		dateLabel.attributedText = attributedText(text: dateFormatter.string(from: header.articleDate).uppercased(),
												  font: .H7Tag,
												  textColor: .white20,
												  alignment: .left)
		durationLabel.attributedText = attributedText(text: duration,
													  font: .H7Tag,
													  textColor: .white20,
													  alignment: .left)
        if let image = header.thumbnail, pageName != .featureExplainer {
            articleThumbnail.kf.setImage(with: image, placeholder: R.image.preloading())
            articleThumbnail.layer.cornerRadius = Layout.CornerRadius.eight.rawValue
            articleThumbnail.contentMode = .scaleAspectFill
            articleThumbnail.layer.masksToBounds = true
        } else {
            articleThumbnail.removeFromSuperview()
            titleTopContraint.isActive = true
            layoutIfNeeded()
        }
    }

    private func attributedText(letterSpacing: CGFloat = 2,
								text: String,
								font: UIFont,
								textColor: UIColor,
								alignment: NSTextAlignment) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: text,
										 letterSpacing: letterSpacing,
										 font: font,
										 lineSpacing: 1.4,
										 textColor: textColor,
										 alignment: alignment,
										 lineBreakMode: .byWordWrapping)
    }
}
