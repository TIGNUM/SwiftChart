//
//  SidebarTableViewCell.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

class SidebarTableViewCell: UITableViewCell, Dequeueable {
    
    // MARK: - Properties

    private lazy var titleLabel: UILabel = UILabel(frame: self.frame)
    private var heightAnchorConstraint: NSLayoutConstraint?

    // MARK: - Init

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with title: String?, font: UIFont?, textColor: UIColor?, height: CGFloat?) {
        backgroundColor = .clear

        guard
            let title = title,
            let font = font,
            let textColor = textColor else {
                return
        }

        let attributedText = NSMutableAttributedString(
            string: title.uppercased(),
            letterSpacing: 4,
            font: font,
            lineSpacing: 4,
            textColor: textColor
        )

        titleLabel.attributedText = attributedText
        heightAnchorConstraint?.constant = height ?? 0
    }

    private func setupView() {
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor == contentView.topAnchor
        titleLabel.bottomAnchor == contentView.bottomAnchor
        titleLabel.leftAnchor == contentView.leftAnchor + 55
        titleLabel.rightAnchor == contentView.rightAnchor - 20
        heightAnchorConstraint = titleLabel.heightAnchor == 0
    }
}
