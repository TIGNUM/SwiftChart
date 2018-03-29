//
//  PrepareContentSubHeaderTableViewCell.swift
//  QOT
//
//  Created by karmic on 23.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PrepareContentSubHeaderTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!

    func configure(title: String) {
        titleLabel.attributedText = NSMutableAttributedString(string: title,
                                                              letterSpacing: 2,
                                                              font: Font.H6NavigationTitle,
                                                              textColor: .black40,
                                                              alignment: .left)
    }
}
