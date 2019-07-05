//
//  MyPrepsFooterView.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyPrepsFooterView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    static func instantiateFromNib(title: String, subtitle: String) -> MyPrepsFooterView {
        guard let footerView = R.nib.myPrepsFooterView.instantiate(withOwner: self).first as? MyPrepsFooterView else {
            fatalError("Cannot load header view")
        }
        footerView.backgroundColor = .carbonDark
        footerView.configure(title: title, subtitle: subtitle)
        return footerView
    }

    func configure(title: String, subtitle: String) {
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                       letterSpacing: 0.2,
                                                       font: .apercuRegular(ofSize: 20),
                                                       lineSpacing: 8,
                                                       textColor: .sand,
                                                       alignment: .left)
        subtitleLabel.attributedText = NSAttributedString(string: subtitle,
                                                          letterSpacing: 0.3,
                                                          font: .apercuRegular(ofSize: 12),
                                                          lineSpacing: 8,
                                                          textColor: .sand,
                                                          alignment: .left)
    }
}
