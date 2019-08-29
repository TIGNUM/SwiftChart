//
//  MyPrepsTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyPrepsTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var calendarIcon: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!

    // MARK: - Lifecycle

    func configure(title: String, subtitle: String) {
        ThemeText.myQOTPrepCellTitle.apply(title.uppercased(), to: titleLabel)
        ThemeText.datestamp.apply(subtitle, to: subtitleLabel)
    }
}
