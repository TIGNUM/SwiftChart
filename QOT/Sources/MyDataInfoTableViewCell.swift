//
//  MyDataInfoTableViewCell.swift
//  QOT
//
//  Created by Voicu on 20.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyDataInfoTableViewCellDelegate: class {
    func didTapInfoButton(sender: MyDataInfoTableViewCell)
}

final class MyDataInfoTableViewCell: MyDataBaseTableViewCell {

    // MARK: - Properties
    weak var delegate: MyDataInfoTableViewCellDelegate?
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleTextView: UITextView!
    private let infoText = " ⓘ "

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(subtitleTextView)
    }

    func configure(title: String?, subtitle: String?, showInfoLink: Bool = false) {
        guard let title = title, let subtitle = subtitle else {
            return
        }
        ThemeText.myDataSectionHeaderTitle.apply(title, to: titleLabel)
        ThemeText.myDataSectionHeaderSubTitle.apply(subtitle, to: subtitleTextView)
        skeletonManager.hide()

        if showInfoLink {
            addInfoLink()
        }
    }

    // MARK: Add the circle info charcter with tap action
    private func addInfoLink() {
        guard let subtitle = subtitleTextView.attributedText else {
            return
        }

        let subtitleMutable = NSMutableAttributedString.init(attributedString: subtitle)
        let infoLinkAttributtedString: NSMutableAttributedString = NSMutableAttributedString(string: infoText,
                                                                                             letterSpacing: 0.3,
                                                                                             font: .apercuRegular(ofSize: 15),
                                                                                             lineSpacing: 8,
                                                                                             textColor: .accent,
                                                                                             alignment: .left)
        infoLinkAttributtedString.addAttribute(.link, value: "MoreInfo", range: NSRange(location: 0, length: infoText.count))
        subtitleMutable.append(infoLinkAttributtedString)
        subtitleTextView.linkTextAttributes = [kCTForegroundColorAttributeName: UIColor.accent] as [String: Any]
        subtitleTextView.attributedText = subtitleMutable
        subtitleTextView.delegate = self
    }
}

extension MyDataInfoTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        delegate?.didTapInfoButton(sender: self)
        return false
    }
}
