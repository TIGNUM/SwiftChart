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

final class MyDataInfoTableViewCell: UITableViewCell, Dequeueable {
    // MARK: - Properties
    weak var delegate: MyDataInfoTableViewCellDelegate?
    private var baseView: QOTBaseHeaderView?
    private let infoText = " ⓘ "

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        baseView = QOTBaseHeaderView.instantiateBaseHeader(superview: self)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(title: String?, subtitle: String?, showInfoLink: Bool = false) {
        guard let title = title, let subtitle = subtitle, let baseView = baseView else {
            return
        }
        baseView.configure(title: title, subtitle: subtitle)

        if showInfoLink {
            addInfoLink()
        }
    }

    // MARK: Add the circle info charcter with tap action
    private func addInfoLink() {
        guard let baseView = baseView, let subtitle = baseView.subtitleTextView.attributedText else {
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
        baseView.subtitleTextView.linkTextAttributes = [kCTForegroundColorAttributeName: UIColor.accent] as [String: Any]
        baseView.subtitleTextView.attributedText = subtitleMutable
        baseView.subtitleTextView.delegate = self
    }
}

extension MyDataInfoTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        delegate?.didTapInfoButton(sender: self)
        return false
    }
}
