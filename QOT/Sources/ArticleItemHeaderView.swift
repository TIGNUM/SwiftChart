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

    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
	@IBOutlet private weak var articleThumbnail: UIImageView!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var titleTopContraint: NSLayoutConstraint!
    @IBOutlet private weak var shareButtonWidthConstraint: NSLayoutConstraint!
    private var shareableLink: String?
    private weak var delegate: ArticleItemViewControllerDelegate?

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        dateFormatter.locale = .current
        return dateFormatter
    }()

    func setupView(header: ArticleCollectionHeader, pageName: PageName, delegate: ArticleItemViewControllerDelegate?) {
        self.delegate = delegate
		var duration = header.articleDuration.uppercased() == "0 MIN" ? "1 MIN" : header.articleDuration.lowercased()
        setupImageView(header: header, pageName: pageName)
        if pageName == .whatsHotArticle {
            shareButton.isHidden = false
            if let shareableLink = header.shareableLink {
                self.shareableLink = shareableLink
                shareButton.isHidden = false
                shareButton.setImage(R.image.ic_share_blue(), for: .normal)
            } else {
                shareButton.isHidden = false
                shareButton.isHighlighted = false
                shareButton.titleLabel?.removeFromSuperview()
                shareButton.setImage(R.image.exclusive_content(), for: .normal)
                shareButtonWidthConstraint.constant = R.image.exclusive_content()?.size.width ?? 128
            }
            duration = " • " + duration + " read"
            authorLabel.attributedText = attributedText(letterSpacing: 0,
                                                        text: header.author?.uppercased() ?? "TEAM TIGNUM",
                                                        font: .ApercuRegular11,
                                                        textColor: .white,
                                                        alignment: .left)
            dateLabel.attributedText = attributedText(text: dateFormatter.string(from: header.articleDate).uppercased(),
                                                      font: .ApercuRegular11,
                                                      textColor: .white50,
                                                      alignment: .left)
            durationLabel.attributedText = attributedText(text: duration,
                                                          font: .ApercuRegular11,
                                                          textColor: .white50,
                                                          alignment: .left)
        } else {
            titleLabel.attributedText = attributedText(letterSpacing: 1,
                                                       text: header.articleTitle.uppercased(),
                                                       font: .H5SecondaryHeadline,
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
        }
		subTitleLabel.attributedText = attributedText(text: header.articleSubTitle.uppercased(),
													  font: .H1MainTitle,
													  textColor: .white,
													  alignment: .left)
    }

    func setupImageView(header: ArticleCollectionHeader, pageName: PageName) {
        articleThumbnail.kf.setImage(with: header.thumbnail, placeholder: R.image.preloading())
        articleThumbnail.layer.cornerRadius = Layout.CornerRadius.eight.rawValue
        articleThumbnail.contentMode = .scaleAspectFill
        articleThumbnail.layer.masksToBounds = true
        if pageName == .featureExplainer || pageName == .libraryArticle {
            articleThumbnail.removeFromSuperview()
            if let titleTopContraint = titleTopContraint {
                titleTopContraint.isActive = true
            }
            layoutIfNeeded()
        }
    }

    func resizedFont() -> UIFont {
        subTitleLabel.font = .apercuRegular(ofSize: bounds.width * Layout.multiplier_09)
        subTitleLabel.addCharacterSpacing(subTitleLabel.font.pointSize * Layout.multiplier_004)
        layoutIfNeeded()
        return .apercuRegular(ofSize: bounds.width * Layout.multiplier_09)
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

// MARK: - Actions

extension ArticleItemHeaderView {

    @IBAction func didTabShareButton() {
        guard let shareableLink = self.shareableLink else { return }
        delegate?.didTapShare(shareableLink: shareableLink)
    }
}
