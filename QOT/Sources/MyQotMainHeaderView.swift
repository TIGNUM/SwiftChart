//
//  MyQotMainHeaderView.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class MyQotMainHeaderView: UICollectionReusableView {

    // MARK: - Properties

//    @IBOutlet private weak var titleLabel: UILabel!
//    @IBOutlet private weak var subtitleLabel: UILabel!

    func configure(title: String?, subtitle: String?) {
        guard let title = title, let subtitle = subtitle else { return }
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                       letterSpacing: 0.3,
                                                       font: .apercuRegular(ofSize: 15),
                                                       lineSpacing: 8,
                                                       textColor: .sand,
                                                       alignment: .left)
        subtitleLabel.attributedText = NSAttributedString(string: subtitle,
                                                          letterSpacing: 0.2,
                                                          font: .apercuRegular(ofSize: 14),
                                                          lineSpacing: 8,
                                                          textColor: .sand60,
                                                          alignment: .left)
    }
}
