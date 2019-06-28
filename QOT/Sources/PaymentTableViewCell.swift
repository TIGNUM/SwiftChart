//
//  PaymentTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class PaymentTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitlelabel: UILabel!    
    // MARK: - Lifecycle

    func configure(title: String, subtitle: String) {
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                       letterSpacing: 0.4,
                                                       font: .apercuMedium(ofSize: 20),
                                                       textColor: UIColor.accent,
                                                       alignment: .left)
        subtitlelabel.attributedText = NSAttributedString(string: subtitle,
                                                          letterSpacing: 0.2,
                                                          font: .apercuLight(ofSize: 12),
                                                          lineSpacing: 4,
                                                          textColor: UIColor.carbon,
                                                          alignment: .left)
    }
}
