//
//  TitleHeaderView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class TitleTableHeaderView: UITableViewHeaderFooterView, Dequeueable {

    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!

    // MARK: - Config Data
    struct Config {
        let backgroundColor: UIColor
        let font: UIFont
        let textColor: UIColor

        init(backgroundColor: UIColor = UIColor.carbon,
             font: UIFont = UIFont.sfProtextMedium(ofSize: FontSize.fontSize14),
             textColor: UIColor = UIColor.sand30) {
            self.backgroundColor = backgroundColor
            self.font = font
            self.textColor = textColor
        }
    }

    // MARK: Configuration
    func configure(title: String?, config: Config?) {
        titleLabel.text = title
        titleLabel.textColor = config?.textColor
        titleLabel.font = config?.font
        containerView.backgroundColor = config?.backgroundColor
    }

    /// TODO: Search & Replace with func configure(_:)
    var title: String = "" {
        willSet {
            titleLabel.text = newValue
        }
    }

    /// TODO: Search & Replace with func configure(_:)
    var config: Config? {
        willSet {
            titleLabel.textColor = newValue?.textColor
            titleLabel.font = newValue?.font
            containerView.backgroundColor = newValue?.backgroundColor
        }
    }
}
